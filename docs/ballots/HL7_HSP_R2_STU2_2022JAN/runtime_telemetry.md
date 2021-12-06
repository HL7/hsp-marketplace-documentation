# Runtime Telemetry

The Marketplace PIM provides the core concepts for issuance of licenses, dynamic digital rights management (DRM) and runtime authorization. Certain types of licensing models, however, require deeper knowledge of the runtime environment for accurate billing and analytics. Similarly, Product telemetry data may need to integrate directly with other systems in a Product runtime environment.

## Use Cases

Real-time monitoring of a Product's runtime characteristics is not just a concern for commercial Marketplace operators. It is a general capability servicing many use cases, such as:

 * Use-based billing
 * Products requiring upstream reporting
 * Performance analytics
 * Clincial research and testing
 * Data warehousing
 * Stream processing of realtime data
 * Debugging issues in complex SOAs
 * Optimizing performance across discrete services

## Industry Consensus

Earlier versions of this specification were largely silent regarding runtime telemetry. This is no longer possible due to the inclusion of Product `marketplace.json` metadata files that must explicitly declare runtime service binding requirements.

While _optional_ for implementers, all `marketplace.json` examples (see [Product Packaging](product_packaging.md)) include a binding to an 'OPENTELEMETRY_COLLECTOR_URL' environment variable. This URL, when present, MUST allow the Product to emit an OpenTelemetry 1.x-compatible stream to a collector provided by the Product runtime environment. [OpenTelemetry](https://opentelemetry.io) is an open and portable telemetry specification merging the functions of the OpenTracing and OpenCensus projects and is actively supported by numerous large technology companies and production environments.
