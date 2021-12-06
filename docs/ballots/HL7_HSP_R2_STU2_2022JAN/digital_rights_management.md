# Digital Rights Management (DRM)

## Product Rights
The architecture of the Marketplace product licensing model adopts several IP rights concepts friendly to both open access and Open Source-licensed products and commercial developers. While DRM considerations are *usually* optional in the former cases, they are often necessary for commercial ISVs and content vendors to have accurate billing, reasonable IP protections, and product improvment insights surrounding their work.

To provide concrete support for the most common Product licensing strategies, several models related to product-level DRM are provided to form the basis of dynamic product authorization tracking and operations.

## Entitlements
Almost all daily consumer interactions with digital content are licensed. Many exceptions exist, such as for Government works and public domain materials outside of copyright, but the average person interacts primarily with copyrighted, licensed digital assets. "Open Source" software under Apache 2.0, MIT, BSD, etc are still licensed for use, even though the Product is "free." Lack of a financial transaction does not imply the absense of copyright nor binding legal obligations.

In the world of "closed source" digital works, licenses are often temporary. For example, renting a movie for online play may only allow for playback within 24 hours from the start of play, 1 week from the time of rental with 2 restarts, only during a special promotional period, or including other complex terms. Materials for trial use or demonstration purposes may have similar restrictions. Access to software applications is enforced in more diverse ways. Clinical content -- especially terminology systems -- are typically made available under custom licenses with less regard for international compatibility and legal robustness than most users assume.

Marketplace 2 introduces a new concept of Product _Entitlement_: an acquired instance of a given Product under an available License. (Details in following sections.)

## Product Families
Products are often released in functional collections, e.g.:

 * hierarchical “families”,
 * promotional groupings,
 * domain bundles, or
 * *en masse* under a subscription-type license.

The API allows arbitrary parent-child nesting of products to support automatic, transitive child authorizations without needing to explicitly grant sub-Product Entitlements to every layer in a product tree. This mechanism also permits users to authorize their use of a Product without needing to know exactly how permission was obtained, which is critical for the volume licensing scenarios common for enterprise products.

### Licenses

A Marketplace "License" defines usage terms outside of any specific product and regardless of any financial requirements of use. Each License defines one of the following types that governs the way Entitlements to it are dynamically interpreted and enforced:

- Indefinite: No time-based restrictions. (e.g. F/OSS products, shareware -- Apache 2.0, MIT, BSD etc)
- Relative: Only valid for a period relative to the datetime the Entitlement was activated. (E.g, long-term subscriptions, short-term rentals, evaluation copies)
- Absolute: (E.g. end of calendar year only, a specific sale date only, etc -- "beta test" ro "pre-release reviewer" use cases)

A given Product may be offered under any number of Licenses. Operators may further define business rules governing which types of Licenses are offered and when, as long as the authorization API endpoints enforce those rules.

When a user acquires a License to a Product (aka "ProductLicense"), the instance of that record constitutes an "Entitlement". The Entitlement is bound to the consumer that procured the Product, and carries additional metadata. Commercial systems may need to extend these records to include references to order processing or ERP data.

All marketplace operators will decide if robust Entitlement management applies to their target audience. For national-level resources, implementors are encouraged to adopt a diverse set of licensing models spanning both commercial and F/OSS works. If fully implemented, the specification supports all of the following revenue models:



| <content id="table">Business Model Revenue Centers<content>        | Example           |
| ------------------ |:-----------------------|
| Service & Support (typically for for F/OSS products, e.g. support tickets, custom development etc) |Red Hat, MITRE
| Recurring Subscription | Office365, Netflix
| Freemium/Pro Advanced features, plugins, SLAs |GitHub, Dropbox, Skype
| Upfront (e.g. 1-time charge per major version) | Kindle books, Physical/Immutable goods, mobile apps
| Use Per Utility Unit (e.g. CPU-hour, transaction, user, object etc) | Amazon, Google, Azure, Oracle
| Advertising (e.g. 3rd-party ad views, pay-per-click) | Google search, "free" games, subsidized hardware

## Dynamic Authorization
Marketplaces implementing the Entitlement portion of the API SHALL provide several API functions for validation of Product Entitlement, aka *dynamic authorization*. These API endpoints may be used by:

1. local Platform Agents
2. Products themselves
3. 3rd-party license managers

This authorization mechanism, when enforcing Entitlement restrictions on usage limits, should verify both time-based criteria and net "claims" to available Entitlements. Marketplaces may provide the baseline simple verification that Entitlements are present and valid, or complex enhancements for directly integrating with financial systems.

Marketplaces that support diverse usage-based or metered business monetization models (as described in the [Business Model Revenue Table](digital_rights_management.md#table) above) may use the Entitlement and Claim capabilities to implement corresponding technical solutions. For example, to:

* Inject raw object data when products are deployed.
* Create time-based constraints.
* Meter usage in realtime, such as by local user count, allocated CPU cores, RAM, invokations etc. 
* Monitor for possible abuse or such as account sharing
* Prevent budget overages.

The dynamic authorization mechanism aims to provide same the core capabilities for commercial and F/OSS products to co-exist under the same set of publishing and procurement principles. Unfortunately, the distinction is not as simple as "F/OSS vs commercial", and with a broad grey area. For example, consider the less common licensing cases:

* F/OSS works that require upstream reporting. This may require Entitlement management even though the upstream vendor does not require a financial transaction to have taken place.
* Entitlements to commercial works that cannot be purchased, and must be granted by the vendor, such as may occur when a vendor:
	* releases updates to a legacy product
	* offers a special product offered _only_ by Voucher (defined in later sections)
	* grant Entitlement via external automation such as marketing signups. (E.g. "free 7-day trial with webinar registration")    

### Claims
An Entitlement represents a specific user's right to "claim" a Product's set of assets, according to the limitations of the specific ProductLicense that was purchased. A given Entitlement -- not the assets themselves -- are always *owned* by exactly one Marketplace *User*. However, _Claims_ of the Entitlement are what is counted against any limits of the License. Additionally, Users may be included in any number of Groups, when desirable. This approach should be used when Claims need to be counted at an aggregate level -- such as for organizational licensing -- and do not need to track User-level access.

Entitlements need not be immediately used. They may be purchased in advance, or by user account completely different from the consumer of the Product. When the owner is ready to use the Product(s), the Product and/or runtime environment may make an API call to the marketplace API to verify user authorization using the Claim object data injected via environment variables.

Every dynamic authorization call MAY create an _Attempt_ record for operator reporting and vendor auditing purposes. It is also intended as a data stream for detecting system abuses such as installation fraud and account sharing.

### Voucher
ISV often distribute evaluation copies of products via digital codes, or even full retain copies through independent resalers. Each code is a human-readable public identifier for a preconstructed Voucher that is bound to exactly one ProductLicense. Thus, Vouchers are *not* a form of "gift card" that may be redeemed for unrelated Products, nor may they be used for the _same_ Product under a _different_ ProductLicense. This allows for several related use cases:

- Channel partner and resale by 3rd-parties. These are often employed by ISVs that do not offer direct sales or prefer the use of outside implementation parters. The end user may thus acquire a Voucher through external means and comes back to the issuing marketplace instance for redemption.
- Offline sales. Internet access is not required for complex manual purchase order processes.
- Promotional giveaways. Voucher codes may be printed and shared via paper, email etc.


### External Transactions
Early feedback on the concept of an ecosystem of compatible marketplaces and runtime platforms revealed inconsistent perspectives for incorporating payment processing directly into this specification. Not all operators are capable of providing (let alone interested in) "checkout" processes often present in commercial platforms; however, commercial vendors may find it absolutely critical. For this reason, the approach of allowing, but not requiring, an ordering process has been adopted.

For products requiring an explicit ordering/checkout process for Entitlement, end users MAY be redirected to an external ordering URL provided by the ISV. If/When the user completes that external checkout flow, the ISV creates an Entitlement via marketplace API prior to redirecting them back to the marketplace. This enables extremely flexible sales processes while preserving a marketplace's ability to manage and authorize Entitlement use.

Alternatively, operators may build checkout processes directly into the Marketplace experience for a more streamlined customer experience. Regardless, marketplace implementations and checkout processes inherently MUST comply with application regulations specific to the operational locale. In locales absent regulatory requirements, implementors SHOULD proactively disclose de facto governing policies and practices.

The ability to externalize payment processing allows for some operators to completely avoid the complexities, administrative and legal challenges of being a middleman in a sales channel. In those cases, focus still must be applied to Product curation activities. Alternatively, operators may do the complete opposite by electing to fully manage the ordering process on behalf of ISVs. Both are acceptable operational models.

## Dependencies and Sublicensure
Interoperable, computable clinical content is enabled by common underlying terminology systems and information models. Presence of required dependencies unfortunately does not imply the consumer holds the right to use those dependencies.

This is further complicated by a jungle of terminology-level licensing models. NLM’s UMLS license defines a tiered class system of licensing terms based on the nature of a work, and is used by RxNorm, VSAC, and many others. US users may only acquire SNOMED CT through UMLS license. Under UMLS model, no means of organization-level licensing is provided, nor a means of redistributing UMLS content: not even for Government organizations. It is woefully inadequate and presents significant headaches for content producers wanting to publish computable content with "plug ‘n’ play" ease. Unfortunately, most informaticians seem to ignore the issue. Violations are commonplace.

The API does not attempt to model all underlying dependency licenses, as it is an implausable task at this time. Rather, operators should establish clear submission policies to set expectations for what is and is not permissable to embed within submitted Products.
