The following table provides a quick overview of all persistent types supported by the Marketplace specification.

## Persistent Resources

| Type                        | Brief Description                     |
| ----------------------------|:--------------------------------------|
| IdentityProvider			| Marketplace instance-level configuration parameters allowing user authentication against an external authority using OpenID Connect authentication flows.
| User						| A distinct person or system with some degree of access or interest to a Marketplace instance.
| (User) Identity			| IdentityProvider-specific information pertaining to a given User.
| (User) Platform			| Declaration of a compatible external Product runtime environment maintained by the User.
| Group						| A named collection of Users for purposes of batch Role assignment.
| (Group) Member			| Essentially a "join" record signifying a given User’s placement within a Group.
| Role						| A named set of permissions.
| (Role) Appointment		| The granting of a single Role to a single User or Group. (It is a polymorphic type.)
| JsonWebToken				| An RFC 7519 JSON Web Token issued to permit access by a given Identity to a Marketplace instance as a bearer token.
| License					| A known software or content license type, required to create Product records.
| Product					| Declaration of a Platform-compatible executable in the form of key metadata. Does not directly provide a reference to an executable image.
| (Product) License			| The offering of a given Product via the terms of a specific License. 
| (Product) Screenshot		| Optional graphical images for illustrating Product features to Users.
| (Product) Build			| Defines the reference to a specific version of an image of a given Product. Images must be hosted such that the Marketplace and its Users have read-only network access, at minimum.
| (Product Build) Dependency			| Known dependencies that are needed to run a given Build of a service. 
| (Product Build) Exposure				| The standardized Interfaces capabilities provided by a given Product Build.
| (Product Build Exposure) Parameter | States that configuration parameter of the given name is required at runtime to successfully provide the Interface of the Exposure.
| (Product Build) Configuration			| The runtime constraints of a Build that need to be known by a Platform for execution.
| (Product Build Configuration) Task	| A container entry point and associated constraints that must be run as part of a Configuration profile.
| Interface								| Marketplace-wide declaration of a standardized – or at least conventionalized – computational integration point. They are not constraints to HL7 standards.
| (Interface) Surrogate					| Marketplace-wide statement that the referenced substitute Interface provides compatible capabilities of the given base Interface. Useful for defining new versions of an Interface that are backwards compatible with older versions.
| Entitlement							| An user-acquired/owned instance of a ProductLicense, also defining activation data specific to the instance. (Note: Groups may _not_ own Entitlements, but may Claim them.)
| Claim									| Polymorphic type representing a user or group usage of an Entitlement against the limits of the underlying License.
| Voucher								| A unique bearer token that may be redeemed for an Entitlement to a defined ProductLicense. The redeeming party may keep the Entitlement for themselves, or assigned it to another User. 
| Attempt								| Audit record of a User or Group trying to authorize usage of given Product. Used for reporting and fraud detection.

## Non-Persistant Resources
A small number of a utility functions are provided that have no directly persistent model in the underlying data store.

| Type                        | Brief Description                     |
| ----------------------------|:--------------------------------------|
| Authorization		| (Not a model type but several endpoints in the API) A set of behavioral calls for clients to dynamically verify that a User or Group is allowed access to a Product via _any_ Entitlement and Product graph pathway, subject to the semantics of all supported Licenes types, restrictions, and additional business policies.
| Status			| A service health check providing the server datetime, session status, and other metadata.
