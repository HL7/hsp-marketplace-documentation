# Health Services Platform (HSP) Marketplace Documentation

This repository contains content and build configuration for the Health Services Platform Marketplace specification as co-developed by Logica Health and HL7, formally balloted by HL7. Product metadata schemas are provided in JSON Schema and a computable version of the Marketplace API is included in OpenAPI format.

If you plan on editing the computable OpenAPI documents, we recommend using [Swagger Editor](https://swagger.io/tools/swagger-editor/) or similar. Compatible alternatives are available, as well.

## Building

Official builds are distributed by Logica Health as Docker images.

	docker run -it --rm --name marketplace-documentation -p 8080:80 logicahealth/marketplace-documentation:latest

Or to build your own:

	docker build -t logicahealth/marketplace-documentation:latest .


This will build and serve a static HTML site at `http://localhost:8080`.


## Building Manually


Install MkDocs

	pip install mkdocs

Install Material

	pip install mkdocs-material

Build and serve the project

	mkdocs serve

The project be available at http://127.0.0.1:8000

