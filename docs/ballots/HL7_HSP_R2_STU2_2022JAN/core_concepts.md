# Core Concepts

## Overview

**The HL7 Health Services Platform Marketplace (HSPM or "Marketplace") specification is a REST API for publication, curation, discovery, procurement, and automated deployment of products and executable knowledge into any compliant IT environment.** It is similar to an "app store" for health IT products in that it facilitates orchestration to a users local runtime infrastructure "Platform" environment and data context. It is not simply a flat directory of SMART-on-FHIR and other UI-only applications, but MAY be used for this purpose. A Marketplace can be implemented by vendors, providers, standards developing organizations (SDOs), consortiums, and all manner of parties interested in an interoperable supply chain of computable solutions across Learning Health Systems (LHS).

The concept of an application "marketplace" or "app store" is nothing new. This HL7 Marketplace specification, in particular, addresses the problem of exchanging computable health artifacts themselves in a vendor-neutral manner, which is necessary to move executable artifacts across SOAs with plug-n-play interoperability. A Marketplace implementation is a hosted service, operated by any interested party, where executable artifacts are published for exchange and governance policies are made operational. Base supported product types include backend CDS Hooks service implementations, SMART-on-FHIR interfaces, CQL, clinical models, raw FHIR resource servers, persistent data stores, and effectively any other product-ized capability that is packaged according to requirements herein.

## Motivations

SMART-on-FHIR provides a means of writing frontend applications backed by FHIR endpoints, as is primarily concerned with client-side *data* integration. It does not venture into *deployment* of those applications into production environments nor how underlying backend dependencies are managed in real-world cybersecurity and software procurement contexts.

Marketplace design principles are inspired by the business processes that made other computing ecosystems such as the (mostly proprietary) Apple, Google, and Amazon app stores successful in general-purpose computing, and creates a vehicle for providers to avoid vendor lock-in by adding support for community-managed Marketplace implementations operated as vendor-neutral consortiums and/or credentialing bodies. This approach has been successful in other domains, and the Marketplace API specification is a building block toward replicating those successes in healthcare.

The Marketplace specification API provides an "app store"-like service fabric for HIT professionals to explore published products, and install them to compatible local or cloud platforms with a one-step experience similar to that of consumer mobile device and desktop software. This allows:

 * HIT orgs to search for new products across all participating software vendors, and deploy them in an automated fashion into on-prem, cloud, and/or hybrid infrastructure, using 1 or more Marketplace instances in any public/private combination.
 * Developers to directly submit new (and update existing) Product Builds.
 * Marketplace operators to curate, review, and publish vendor Product submissions.
 * Compliance validators to automate certification activities and notify deployed Platform environments of critical updates.
 * Parties to optionally authenticate with existing SSO credentials shared by other SoF apps/architectures.
 * Users to dynamically and automatically authorize product use via trusted operators.
 * Auditors to collect reporting data on the licensed usage of published products.

An additional benefit is agnosticism to programming language, development framework, database, I/O technologies, and most notably, EHR vendor. It permits architectural flexibility without require implementors to support any specific Product technology standard.

## For Providers and Software Vendors

For an HIT professional interested in using a Marketplace, he/she is assumed to operate in a functional environment where certain business capabilities of running 3rd-party sotfware are already present. This local environment, or Health Services Platform -- HSP or "Platform" for short -- is further assumed to directly integrate with one or more Marketplace implementations. There is no presumption of HL7, Logica Health, Graphite Health, EHR vendor, government entity, or any other monopolistic distribution channel for Product. Certainly jurisdictions may be require operators to establish a many-to-many relationship between marketplaces and runtime platforms in the future.

The Marketplace specification intentionally omits one area of particular interest to vendors that must be addressed by the Marketplace implementer: processing of financial transactions. Version 2 STU1 (and forward) support sophisticated product licensing models and version 2 STU2 adds `marketplace.json` product packaging and metadata support; however, any/all billing and payment processing based on those terms are at the discretion of the operator, their target market, and locale. We do not prescribe any particular "checkout" experience or user flow, but recognize it is critical for certain operators.

Adoption for distribution of commercial Products is highly encouraged. Commercial software vendors MUST allow limited use of their Product Build images (by a marketplace operator) for validation, evaluation, and integration testing purposes prior to achieving a "published" state in a Marketplace and MUST remain so to support automated deployment. In the same vein, Marketplace operators focused on free/open source software (F/OSS) products are able to omit use of the Product authorization runtime check API entirely.

## For Marketplace Operators and Validators

The Marketplace specification includes a lightweight product curation mechanism. It is assumed that the operator of a Marketplace instance does so, in part, as a gateway, certifier, validator, signatory, distributor, or other form of endorser to the products offered for deployment. For example, a FHIR service validation company may integrate with automated test suites to verify builds of a product submission claiming to support US Core profiles does, in fact, behave as expected as part of the build publication workflow. Further, specialty societies with particular clinical domain interests may use Marketplace implementations as a vehicle for "endorsing" vetted products with badging mechanisms to communicate levels of clincial trust.

Compliance and quality assurance organizations may also take interest in the service functional model (SFM) in which a Marketplace implementation is operated, as the curation mechanic is intended to be extended with standard-specific, deep integrations with 3rd-party build validation. Conceptually, this approach creates a standards-based ecosystem for validation by allowing ISVs to independently submit a given Product Build to multiple credentialing organizations without making vendor-specific concessions regarding the way the executables are packaged. As long as Marketplace Product packaging requirements are met, a byte-identical image may be cross-certified and distributed by unrelated operators simultaneously.

## Platform Agent

A Plattform Agent is a minimal service running on the customer's local runtime Platform subscribed to state changes events emitted by a Marketplace, for change deployment via the native local orchestration system. The Agent service is intended to be minimal in nature, only bridging the Marketplace API with local orchestrator control plane. Agents are completely optional and not part of the Marketplace API specification, but are the most significant consumer of any push events send by a Marketplace server. IT professionals are welcome to use a Marketplace without automated deployment capabilities when desired.

The Agent proof of concept referenced in supplementary sections shows how push messages sent from a Marketplace may be translated into local deployment and provisioning events. More sophisticated deployment profiles are the responsibility of the orchestration system and Platform operator. In any case, implementers are encouraged to use a stateful system for Platform management to match the stateful nature of the Marketplace’s state-based synopsis of local capabilities.
