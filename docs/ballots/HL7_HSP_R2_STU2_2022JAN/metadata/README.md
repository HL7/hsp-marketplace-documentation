# Marketplace Metadata & Packaging

This repository contains the JSON schema definitions (and corresponding examples) for the Logica/HL7 Marketplace Product Packaging & Metadata specification. Publication of any health IT software product compliant with the Marketplace API _must_:

1. Be packaged according to Marketplace standards and conventions
1. Include a corresponding `marketplace.json` file for each build of the product.

The technological portion of Marketplace-compliant "product packaging" boils down to the process of building applications in a more conventionalized manner than OCI-compliant images alone  (e.g. those already containerized) can produce, as the Marketplace specification requires:

* Usage metering via a set of predefined configurations injected at product runtime, even for static content assets.
* Strict dependency version whitelists that must be resolvable both at the time a product is published and deployed. 
* SMART-on-FHIR applications and other software to auto-bind certain configuration parameters specific to the target environment.
* Agnosticism to orchestration platform with no presumption of the specific features of Swarm, Kubernetes, OpenShift etc, such that a product can be distributed to all manner of mainstream runtime environments.
* Every software (or content) product be deployable automatically in a "zero configuration required" philosophy.
* "Just in time" configuration resolution but with advance runtime platform compatibility checking prior to the application of changes.  
* Platform implementations to account for the idiosynchrasies of specific mesh orchestration technologies that cannot be addressed at the Marketplace level.

# Examples
## Static Content Products
The simplest type of product is one or more static assets that are licensed and consumed in a "utility" model. That is, each access is securely authorized and logged against a "meter" used for analytics and billing. In this context, the "product" is simply a set of static files wrapped in runtime authorization and metering against Marketplace-compatible APIs. Those capabilities provide the basis for sophisticated sales and licensing model.

## SMART-on-FHIR Software Products

SoF (SMART-on-FHIR) applications and other software backed by a FHIR requires the authentication and authorization flow(s) of OpenID Connect and OAuth, as well as dynamic runtime binding to a FHIR endpoint. All Marketplace-compliant products _must_ treat those variables -- including app URL -- as runtime configuration parameters injected during startup. "Baking in" credentials, backend URLs, or any other form of environment-sensitive configuration is strictly prohibited. Examples of configuration injection for SoF apps is available.


# Deploying

The files in this project are distributed in pre-built containers. A recent copy is provided at:

    https://marketplace-packaging.logicahealth.org

To build your own:

    docker build -t p3000/marketplace-packaging:latest .

To run your own at http://localhost:8080

    docker run -it --rm -p 8080:80 p3000/marketplace-packaging:latest

# Attribution
Preston Lee (GitHub: @preston)
