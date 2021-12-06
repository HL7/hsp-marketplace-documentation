# API
The Marketplace API is designed as a medium-weight, conventional specification that is straightforward to implement using any number of common-off-the-shelf (COTS) Open Source technologies, and is easy to understand for simple use cases. Additional considerations have been made for current trends in standards and interoperability.

## Machine-Readable Format

**Swagger API**: The following OpenAPI documents capture descriptions of the Marketplace APIs in machine-readable format: **[JSON](./openapi.json) [YML](./openapi.yml)**

## Platform Independent Model
The core resources managed by the API are shown in the logical model illustrated in Figure 3, and will be discussed in subsequent subsections.

![ Platform independent model (PIM)](Image5.png " Platform independent model (PIM)") 

## User Identity & Authentication

A Marketplace MUST use OpenID Connect – part of the OAuth 2 family – for Marketplace user authentication using an external single sign-on (SSO) system. Implementations MAY provide support for other SSO protocols/systems including SAML 2.0 and CAS, but OpenID Connect is the required minimum. OAuth 2 enjoys broad main stream support outside of healthcare, is familiar to enterprise architects, and works well for both mobile and headless clients.


In addition to being a relatively simple specification to implement in most cases, OpenID Connect and OAuth 2 are the basis of SMART-on-FHIR (SoF) authentication and authorization. Marketplace use of OpenID Connect for authentication is not otherwise related to or dependent upon SoF nor FHIR. Likewise, the Marketplace is not a FHIR specification and does not provide APIs as FHIR resources. Philosophically, the Marketplace API loosely follows the REST principle of Hypertext as the Engine of Application Status (HATEOAS), with the aim of making application usage consistent and easy to navigate across resource types.

The specific selection of OpenID Connect is intended to enable new and creative means of supporting FHIR-focused Marketplace implementations, when applicable, by providing out-of-the-box compatible authentication against the same external identity provider(s) used for SoF authorization. To reiterate, however, FHIR-based Products or Builds are not required. It is no less valid to operate a Marketplace implementation supporting older, alternative and/or unrelated standards. The authentication and authorization objects discussed in subsequent sections are completely unrelated to any similar records that may be present in specific FHIR Products that happen to be published in a Marketplace.

For web-based clients, this implies the use of RFC 7519 JSON Web Tokens (JWTs) within HTTP header bodies to establish the session upon each call. See the JTW/RFC 7519 specification3 for implementation and usage information.

## Role-Based Access Control
The PIM establishes role-based access control (RBAC) at the User and Group levels using a small number of types. Of particular note is a separation of the User from that of an Identity. A User is an individual or client actor, whereas an Identity is an issuer-specific credential establishing authentication information about a User according to the remote authority. Rights are assigned at the Role level via a fine-grained "permissions" field that is recommended (but not required) to be represented internally as JSON to match the JSON format exposed by the Role API. (See Table 1 for an example.)

Each Role MUST provide a permissions object in the form of a JSON associative array, which defaults to an empty "{}". This object MAY grant any number of permissions based on the resource type (noun) and operation (verb) of interest. For example:

	{"everything" : {
		"manage": true
		},
	"users": {
        "create": false,
        "read": false,
        "update": false,
        "delete": false,
		"update_self": false,
        "read_self": false
    	},
    "groups": {
        "create": false,
        "read": false,
        "update": false,
        "delete": false
        },
    "products": {
        "publish": false,
        "create": false,
        "read": false,
        "update": false,
        "delete": false
        }
		...
	}

The permissions object MUST ONLY apply to globally-defined Roles. Implementers MUST allow a User to manage their own Identity, Platform, Instance, and other User-scoped resources without explicit permissions, as well as implicitly grant read access (without explicit permissions) for system objects required to log in via OpenID Connect, such as IdentityProvider. Implementers MAY provide global paths for querying sub-resources without reference to their naturally defined parent resource -- e.g. "GET <root>/platforms" in lieu of "GET <root>/users/:id/platforms" -- and in this case a permission set for "platforms", "identities" etc would/will apply regardless of the ability to access the parent record.

As a further example of implicit access, a Product MUST be readable, at minimum, by its owner. Management of sub-resources by the owner of the Product, notably Build, SHOULD also be deemed as manageable by the owner, but SHOULD NOT allow limitless control. In the case of Builds – nested within Products as "/products/:uuid/builds" – and other types in that tree, permission to access a sub-resource does not implicitly grant the ability to access the parent, and vice versa. Implementers MAY allow for adaptation, but implementers MUST take care to not inadvertently allow bypass of access controls by querying for related records that include the unauthorized resource.

### Administrative Permission Short Circuiting
A single special global-administrator privilege MUST be supported on the Role permissions field object. This implicitly grants unlimited access to the system for any Role(s) holding it.

	{"everything" : {
		"manage": <true|false>
		},
		...
	}`

### Permission Semantics
Additional permission-level decisions are left to the discretion of the implementer, as are any notion of "built in" or "default" Roles. A Role may be assigned to any combination of User or Group types via a polymorphic Assignment. The set of permissions defined across all roles must support arbitrary unions of the various permissions while still supporting clear "deny-allow" semantics. That is, a User or Group is assumed to not hold a permission until/unless it is explicitly granted by an assigned Role. Users/Groups may hold an Assignment to 0..* Roles, and vice versa, and special semantics SHALL NOT be given to the order in which Assignments have been made. A given User or Group SHALL NOT be allowed to hold multiple Assignments to the same Role.

### Permission Conflict and Non-Revocation
As the Marketplace RBAC operates on a strict deny-allow semantic, no mechanism is supported to permit "revocation" of privileges or anti-Roles. While defining a mechanism may be tempting to supporting Roles such as "suspended users" or "provisional accounts", doing so would be overly complicated for most implementations. Setting the value of a permission to "false", null, or any other non-true value SHALL NOT have any effect. For example, in cases where a permission is set to true in a Role and false in another, the values SHALL be "or’d" together. In other words, any true value in any Role grants the permission of interest.

## Products, Builds, and Images
A Product is a structured declaration of capabilities for a package of executable or consumable content, with release managed in a discrete lifecycle. A CDS Hooks or FHIR Terminology product "ExampleProduct" developed by vendor "ExampleSoft", for example, would be declared to a Marketplace instance prior to actual release of the software to establish descriptive text, create screenshots, set standards-related declarations, and other fields.

Builds are concrete, versioned instances of a Product, and is the product versioning mechanism used by the Marketplace. As ExampleSoft provides ongoing development of ExampleProduct and is ready to release a new version for public deployments, a new Build resource is created under the existing Product declaration with a distinct version within the scope of that Product. Build versions SHOULD adhere to semver4 semantics. An additional "ordinal" field is provided for Builds that do not adhere to a lexicographically sortable versioning scheme such as hashes or code names. Informal automated Builds made on a recurring basis such as "latest" or "nightly" SHOULD NOT reuse an existing build definition, but MAY so long as this is clearly communicated to the user via other metadata. Distinct Builds are not assumed to be "rolling" or "rebuilt" on a recurring basis.

To ease operational requirements for operating a Marketplace, the Marketplace does not include a mechanism for uploading software executables. Instead, these Images are declared by reference within the Build record. Images MUST be OCI compliant and be downloadable from the public Internet without special authentication, authorization, or human intervention. (See What is a "Health Product"? for Image packaging requirements. Implementations MAY implement their own image hosting and management solutions, but this is neither necessary nor required. Numerous general-purpose solutions for management of OCI-compliant images are already available.

## Standards Compliance Declarations
To facilitate automated validation, automated deployment, and autowiring, the Marketplace declares a system-wide collection of standardized Interface types known and supported by the instance. Each Interface MUST have a distinct URI and name, MUST have a version, and MAY have an additional ordinal value. The ability of an Interface to subsume the capabilities of another Interface – for such cases where v2.1 is a superset of all v2.0 functions, for example – is provided via separate Surrogate records. In this example, v2.1 would be allowed to serve as a Surrogate for other Product Builds declaring a Dependency on v2.0.

When ExampleSoft submits a new build of ExampleProduct, they SHOULD declare adherence to each applicable Interface supported by the Marketplace instance. This declaration is made via 0..* Exposure records subordinate to the Build. Each Exposure thus makes a statement such as, "ExampleProduct build v1.2.3 provides XYZ API v4.5.6". The exact meaning of this is naturally specific to the standard being supported by the Build. Enhancements to the Exposure resource are expected in the future to allow for more robust declaration of highly varied types of Interfaces. Healthcare’s widespread use of model "profiling" – a practice far less common in other domains -- makes defining a solution challenging up front. The Interface URI space is intentionally left undefined, though future definition of a global registry may also be warranted. Marketplace operators are encouraged to collaborate on common URIs to avoid Marketplace operator-specific URI declarations.

When a build is deployed, it may set a number of instance-specific Parameters based on the declared Exposures. These are to be used for autowiring purposes, and let local Agents know which settings of the Build, if any, should be visible to other Products/Builds deployed in the future.

Similarly, to support automated deployment, Builds MUST declare their external Product dependencies via Dependency resources if/when they are supported by that Marketplace instance. Dependencies, like Exposures, are specific to each Build, and will likely by refined with additional fields in the future to support more advanced use cases.

The last sub-resource supported by Build is 0..* Configurations. A Configuration contains the runtime and Build entrypoint information essential for a local Agent to execute the Build according to ExampleSoft’s runtime requirements. To illustrate, say ExampleProduct requires a deployment consisting of:

* 2+ containers running a web server
* 1+ background workers
* 1 external database
* 0-1 email servers

For autodeployment to be possible, this Configuration MUST contain a Task resource for each line item. Configurations MUST reference a single Build (and transitively exactly 1 Image). Therefore, Configurations and Tasks MUST ONLY require a single Build to operate. This may change in the future; however, it is not recommend as doing so complicates the entire functional model.

## Configuration State Tracking
One of the more advanced use cases for a Marketplace is fully automated, autowired Product deployment from an external environment into a local platform environment. For a Marketplace to provide intelligent search and filter capabilities for users, it therefore must have some notion of what existing Products are present, regardless of the management system responsible for managing the hosting environment.

Each User MAY declare 0..* Platforms that SHOULD correspond to the environments integrated with that Marketplace instance. Each Platform MUST have a distinct name (relative to that User), which in turn contains 0..* Instance resources. Each Instance refers to the specific Build of the Product running in that Platform environment and contains a JSON field for configuration information set by the Platform agent at runtime. In this initial version of the Marketplace API, there is no ability to define local Products that are not otherwise known to the Marketplace. This may change in the future.

## Endpoint Overview
A complete list of endpoints defined by this specification, including all applicable noun/verb combinations, is provided in plain text format within the accompanying ballot package. This "routes" file is useful for quickly understanding the scope of effort required for implementation and/or consumption.

## Resource Commonalities
Please read and understand this section in entirety prior to the subsequent Endpoints section. It is required for successful implementation.
The entire Marketplace API applies a consistent view of RESTful product design with a mission of optimizing ease of consumability for applications developers. A few general principles apply to all resource types.

### Endpoint Noun-Verb Paths
For a example resource type "resource", paths are always lower case and plural. The following table shows the way resource paths are constructed and the Role permission required to use it. This pattern is repeated for every type of resource unless otherwise noted.

| HTTP Verb        | Path     |Semantic           |Required        |Required Role Permission           |
|-------- |-------- |-------- |-------- |-------- |
| GET		| /resources				| Paginated and filtered index of resources	| Yes	| {"resources" : {"read" : true }}|
| POST		| /resources				| Create a new resources, automatically assigning a valid UUID if not provided.	| Yes	| {"resources" : {"create" : true }}|
| GET		| /resources/:uuid		| Read the specified resource	| Yes	| {"resources" : {"read" : true }}|
| PUT or PATCH	|/resources/:uuid	| Update the specified resource	| Yes	| {"resources" : {"update" : true }}|
| DELETE	| /resources/:uuid		| Delete the specified resource	| Yes	| {"resources" : {"delete" : true }}|
| POST		| /resources/search		| Create a paginated list of resources functionally beyond "GET /resources"	| No	| {"resources" : {"read" : true }}|

 
For nested resources (aka sub-resources or container resources), the relative path is always appended to the path of the parent in which it is contained. For example, if resources contains Bar resources, Bars would be located at `/resources/:uuid/bars`. Semantically, this relationship MUST imply a specific composition structure binding the lifecycles of the parent and child.
When the parent is deleted, all children MUST be deleted unless otherwise specified.
When a child is deleted, the parent MUST NOT be automatically deleted.

### UUIDs
All ID types are non-sequential, 128-bit UUIDv4 unless otherwise specified. These are well supported by databases and may also be easily generated using off the shelf libraries available for all popular programming languages. All fields with an "id" in the name are of a UUID type.

### Timestamps
All resources instances have "created_at" and "updated_at" datetimes that are maintained by the system. They MUST NOT be modifiable by a client/User, regardless of permissions. These and other datetime types MUST be exposed via the ISO 8601 standard, selected due to globally common use, ease of integration with other systems, and consumability by all common programming languages without custom parsers both inside and outside of healthcare. Any datetime value presented without an explicit time zone MUST be interpreted to be in UTC.
ISO 8601 allows for time zones to be serialized with a datetime string. For datetime fields settable by clients, implementations MUST accept any/all valid embedded time zone values. Regardless of submitted time zone value, implementations SHOULD normalize internally to Universal Time Coordinated (UTC) for database operations and MUST expose them in UTC form back to clients. Clients are responsible for apply any offsets for display purposes based on client-side locale settings. Alternatively, Marketplace implementations MAY provide support for customizable "default" client time zones, but this is discouraged as application of client time zone offsets is generally better handled on the client side and can complicate database implementation operations on the server side. 

### Paths and URLs
Similar to timestamps, all resource instances also have "path" and "url" fields automatically generated and managed by the server. These fields MUST NOT be modifiable by a client, regardless of permissions. A "path" MUST be a path relative to the detected root URL of the deployed implementation, e.g. "/resources".
A "url" is a full, valid URL of the resource, e.g. "https://marketplace.example.com/resources". The protocol portion of the URL SHOULD match that of the request; implementations MAY force this value to be "https" if automatic http->https redirection is not present in the environmental configuration.

### Index Pagination & Filtering
**Performing a GET operation at a resource’s base path `/resources` always retrieves a paginated index of the resource**, subject to Role-Based Access Control. Pagination support MUST be implemented for all resource indexes. Filtering is optional.
Pagination and filtering are controlled using two query parameters:

Table 2 Index pagination and filter parameters

| Parameter        | Default           |Constraints           |Example           |
|------------------ |-----------------------|-----------------------|-----------------------|
| page			| 1			| 1-based positive integer	| 42	|
| per_page		| 10		| Positive integer 1 or greater	| 50	|
| field_name	| ignored	| MUST be imply into the correct type. Non-strings MUST be matched exactly. Strings SHOULD be fuzzy matched. |	name=preston <br> version=1.0.0 |
| sort			| field_name	| Must be a valid, accessible field if provided. Otherwise, implementations may select the default field for sorting, if any.	| name |
| order			| undefined	| Must be "ascending" or "descending" if present. Otherwise, implementation may provide any ordering.| ascending	|

Implementers MAY allow empty "dumps" of a resource by providing a per_page of 0, though this is not recommended for types expected to have a large number of underlying collections to avoid "N+1" and similar performance issues.
The response to an index operation MUST follow the below template, created to provide the easiest possible path for client developers to navigate the paginated results. This is based on real-world usage within hundreds of existing applications.


### Search
Performing a GET operation at a resource’s base path ("/resources") retrieves a filtered index according to Index Pagination & Filtering. Implementors MAY provide an additional "POST /resources/search" with the same parameters if POSTing is required by client code.
 
##Special Endpoints
Several one-off endpoints differ from the conventions defined in Resource Commonalities. These are listed below.

| HTTP Verb        | Path           |Purpose           |Template           |
|------------------ |-----------------------|-----------------------|-----------------------|
| GET	| /	| Root path	| `{"message": "This product provides an API only and does not offer a built-in graphical interface."}`
| GET	| /status	| System availability and health.	| `{    "message": "This application server and underlying database connection appear to be healthy.",    "product": {        "datetime": "2018-11-27T21:30:05.967-07:00"    },    "database": {        "datetime": "2018-11-28T04:30:05.967+00:00"    }}`|
| GET	| /sessions	| OAuth 2 callback after authentication	| Redirect to client URL with "jwt=…" parameter or return JWT: {"jwt": "…", "authorization": "Bearer …"} 
| POST	| /session	| Begin OAuth2 authentication for given provider_id	| Redirect to IDP corresponding to provider_id (See additional option in )
| DELETE	| /session	| Invalidates given JWT authentication header	| `{"message": "Logged out."}`



## Endpoints
Resource templates and resource-specific notes for all supported types are provided in the following sections. Please read sections on resource commonalities prior to endpoint-specific sections, as only resource-specific data structures are covered here. Recall that all indexes are paginated.
 
### IdentityProviders (/identity_providers)
An IdentityProvider is a deployment-specific resource containing client configuration information for a resource OpenID Connect authentication/authorization server. This information changes very infrequently.
Of special note is the "public_keys" field, which SHOULD be polled and updated automatically. Issuers typically cycle through keys pairs frequently and failing to update them will result in failed User authentication flows.

### Users (/users)
Users resources represent the individuals or applications making Marketplace API requests.

### Identities (/users/{userId}/identities)
An Identity contains the IdentityProvider-specific information for a given User that has authenticated against the supported IdentityProvider. Most of the fields are provided from the IdentityProvider during authentication.

### User Platforms (/users/{userId}/platforms)
A Platform is a User declaration of a compatible local runtime environment, possibly managed by an automated Agent.

### User Platforms (Product) Instances (/users/:id/platforms/:id/instances)
A Product Instance declares a running instance of a known Build on a specific User Platform.

### Groups (/groups)
A Group allows for batch assignment of Roles to a collection of Users.

### Members (/groups/{groupId}/members)
A Member resource assigns a given user to a group.

### Roles (/roles)
A Role is a declaration of a fine-grained set of permissions. The "default" Boolean field MUST specify whether or not the Role will be automatically Appointed to new User/Group resources from this point in time at which it is set to true and forward.

### Appointments (/roles/{roleId}/appointments)
A Role Appointment is a polymorphic type assigning a Role to single User or Group.

### Licenses (/licenses)
A known software or content license type, required to create Product records.

### Products (/products)
Declaration of a Platform-compatible executable in the form of key metadata. Does not directly provide a reference to an executable image.

### ProductLicense (/products/{productId}/licenses)
The Licenses under which a given Product is made available for Entitlement. 

### Builds (/products/{productId}/builds)
Defines the reference to a specific version of the image of a given Product. Images must be hosted such that the Marketplace and its Users have read-only network access, at minimum.

### Dependencies (/products/{productId}/builds/{buildId}/dependencies)
A Build Dependency is a runtime requirement of a given Product. 

### Exposures (/products/{productId}/builds/{buildId}/exposures)
A Build Exposure declares that a given Product Build provides capabilities required of a known Interface. 

###  Configurations  (/products/{productId}/builds/{buildId}/configurations)
A Product Build Configuration outlines the deployment profile of a running Instance in initial operating capacity. 

### Tasks (/products/{productId}/builds/{buildId}/configurations/{configurationId}/tasks)
A Product Build Configuration Task defines a container-based command needed to run the Configuration of the (transitively referenced) Build.

### Surrogates (/products/:id/surrogates)
An Interface Surrogate declares that the reference substitute provides compatible capabilities of the given Interface. See Standards Compliance Declarations.

### Logos (/products/{productId}/logos)
Optional graphical images for identifying products

### Screenshots (/products/{productId}/screenshots)
Optional graphical images for illustrating Product features to Users.

### Interfaces (/interfaces)
An Interface declares system-wide knowledge of a standardized – or the least conventionalized – computational interface. See Standards Compliance Declarations.

### Entitlement	(/entitlements)
User-acquired/owned instances of ProductLicenses, also defining activation data for each specific instance. (Note: Groups may _not_ own Entitlements, but may Claim them.)

### Claim (/entitlements/{entitlementId}/claims)
Polymorphic type representing a user or group usage of an Entitlement against the limits of the underlying License.

### Voucher (/vouchers)
Uniqiue bearer tokens that may be redeemed for an Entitlement to a defined ProductLicense. The redeeming party may keep the Entitlement for themselves, or assigned it to another User.

### Attempt (/attempts)
Audit record of a Users and Groups trying to authorize usage of Products. Used for reporting, fraud detection, and analytics.

### Authorization (/authorizations/users/:user_id/products/:product_id and /authorizations/groups/:group_id/products/:product_id)
A set of behavioral calls for clients to dynamically verify that a User or Group is allowed access to a Product via _any_ Entitlement and Product graph pathway, subject to the semantics of all supported Licenes types, restrictions, and additional business policies.

### Status (/status)
A service health check providing the server datetime, session status, and other metadata.

### WebSockets (/websockets)
The WebSockets interface is an experimental bidirectional TCP channel established between a client, such as an Agent, to receive push notifications around Marketplace activity. This is an OPTIONAL feature and no strict protocol exists at this time for implementation. This area of the specification is expected to expand greatly in future revisions to standardize the message format, subscription mechanism, and scope of function.
See notes in Marketplace Product for starting points and exploration of the proof-of-concept pub/sub mechanism used by external reference materials.
