# Core Concepts

## Overview

**The HL7 Health Services Platform Marketplace (HSPM or "Marketplace") specification is a REST API for publication, cataloging, discovering, and deployment of products and executable knowledge into any compliant IT environment in an automated manner.** It is similar to an "app store" for health products in that it manages deployment to a users local infrastructure "Platform" environment and data context. It is not a flat directory of SMART-on-FHIR and other UI-only applications, but MAY be used for this purpose. A Marketplace can be implemented by vendors, providers, standards developing organizations (SDOs), consortiums, and all manner of parties interested in interoperable services.

The concept of an application "marketplace" or "app store" is nothing new. This HL7 Marketplace specification, in particular, addresses the problem of exchanging computing health artifacts themselves in a vendor-neutral manner, which is necessary to move executable artifacts across SOAs with plug-n-play interoperability. A Marketplace implementation is a hosted service, operated by any interested party, where executable artifacts are published for exchange and governance policies are defined. This includes backend CDS Hooks implementations, runnable ECA rules/Order Sets/Documentation Templates derived from HL7 CDS Knowledge Artifacts, HL7 CQL, clinical models, raw FHIR resource servers with known capabilities statements, persistent data stores, and effectively any other product-ized capability that is packaged according to requirements herein.

## Motivations

The Marketplace specification is not simply a "gallery" designed for automated SMART-on-FHIR (SoF) launch authentication and authorization wiring. SMART-on-FHIR launch addresses the extensions for FHIR servers and OAuth 2 scopes required for access to FHIR resources. SoF only concerns client-side app integration, however, and does not venture into deployment of client applications nor additional backend services: extremely common tasks in enterprise IT. (Note, the Marketplace specification does not intrude on the context synchronization mechanisms of HL7 CCOW and related projects that may depend on OAuth-based infrastructure. Context synchronization and management is out of scope.)

Marketplace design principles are inspired by the business processes that made other computing ecosystems such as the (mostly proprietary) Apple, Google, and Amazon app stores successful in general-purpose computing, and creates a vehicle for providers to avoid vendor lock-in by adding support for community-managed Marketplace implementations operated as vendor-neutral consortiums and/or credentialing bodies. This approach has been successful in other domains, and the Marketplace API specification is a building block toward replicating those successes in healthcare.

The Marketplace specification also provides an "app store"-like experience for HIT professionals to explore published products, and install them to local or cloud environment with a point-and-click experience similar to that of consumer desktop software and proprietary IaaS. This allows:

* HIT orgs to search for new products across all participating vendors, and deploy them in an automated fashion into on-prem, cloud, and/or hybrid infrastructure, using 1 or more Marketplace instances in any public/private combination.

* Developers to directly submit new (and update existing) Product Builds.

* Marketplace operators to curate, review, and publish vendor Product submissions.

* Compliance validators to automate certification activities and notify deployed Platform environments of critical updates.

* Parties to optionally authenticate with existing SSO credentials shared by other SoF apps/architectures.

* Users to dynamically and automatically authorize product use via trusted operators.

* Auditors to collect reporting data on the licensed usage of published products.

An additional benefit of the specification is a complete agnostic to the programming language, frameworks, database, I/O technologies, and most notably, EHR vendor. It permits more architectural flexibility for  SMART-on-FHIR clients, CDS Hooks services, and executable knowledge that requires on-site deployment, but does not require implementors to use any of those specifications.

## For Providers and Software Vendors

For an HIT professional interested in using a Marketplace, he/she is assumed to operate in a functional architecture where certain business capabilities are present within the target HIT environment where products and executable knowledge will be deployed. This local environment, or Health Services Platform (HSP, "Platform") for short, requires several core capabilities, and is further assumed to integrate with an ecosystem of Marketplace implementations. There is no presumption of HL7, Logica, EHR vendor, government entity ,or any other party monopolizing the distribution channels for computable health products. If anything, it should be assumed that a local HIT environment with Marketplace integration will support _multiple_ public and proprietary Marketplaces each offering a diverse mix of products.

The Marketplace specification intentionally omits one area of particular interest to vendors that must be addressed by the Marketplace implementer: financial transactions. While version 2 (and forward) supports sophisticated product licensing models, it is intended that parties requiring inline payment processes will implement "shopping cart"-like features on top of the core Marketplace object types, and that these extensions will be tailored to the operator context. The specification does not directly define a "checkout" experience or user flow, but is aware that it is critical for certain use cases.

Publication of commercial asset images is highly encouraged. Commercial software vendors MUST allow limited use of their Product Build images for validation, evaluation, and integration testing purposes prior to achieving a "published" state in the Marketplace and MUST remain so to support automated deployment. In the same vein, Marketplace operators focused on free/open source software (F/OSS) products may be able to omit complex licensing and sales mechanisms entirely.

## For Marketplace Operators and Validators

The Marketplace specification includes a lightweight product curation mechanism. It is assumed that the operator of a Marketplace instance does so, in part, as a gateway, certifier, validator, signatory, distributor, or other form of endorser to the products offered for deployment. For example, a FHIR service validation company may integrate with automated test suites to verify builds of a product submission claiming to support US Core profiles does, in fact, behave as expected as part of the build publication workflow. Further, specialty societies with particular clinical domain interests may use Marketplace implementations as a vehicle for "endorsing" vetted products with badging mechanisms to communicate levels of clincial trust.

Compliance and quality assurance organizations may also take interest in the service functional model (SFM) in which a Marketplace implementation is operated, as the curation mechanic is intended to be extended with standard-specific, deep integrations with 3rd-party build validation. Conceptually, this approach creates a standards-based ecosystem for validation by allowing ISVs to independently submit a given Product Build to multiple credentialing organizations without making vendor-specific concessions regarding the way the executables are packaged. As long as Marketplace Product packaging requirements are met, a byte-identical image may be cross-certified and distributed by unrelated operators simultaneously.

## Health Services Platform Agent

An Agent is a minimal service running on the local Platform listening for state changes in target platform state, as perceived by all configured Marketplace(s) as well as the local orchestration system. The Agent process is intended to be minimal in nature, only bridging the Marketplace API with the native platform orchestration system. It is completely optional and not part of the Marketplace API specification, but the most significant consumer of any push events send by a Marketplace server. IT professionals are welcome to use a Marketplace without automated deployment capabilities if desired.

The Agent proof of concept referenced in supplementary sections does very little, only showing how push messages sent from a reference Marketplace may be translated into action by the container platform. More sophisticated deployment profiles are the responsibility of the orchestration system and Platform operator. In any case, implementers are encouraged to use a stateful system for HSP management to match the stateful nature of the Marketplace’s synopsis of local capabilities.
