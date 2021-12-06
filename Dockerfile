# We're separated the build from runtime stages. First, the build:
FROM python:slim as MKDOCSSTAGE
# Install dependencies first for layer caching.
RUN pip install mkdocs
RUN pip install mkdocs-material
# Copy in the source and actually build it.
COPY . /build/
WORKDIR  /build/
RUN mkdocs build

# Now, copy the built site into a production-optimized nginx image:
FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=MKDOCSSTAGE /build/site /usr/share/nginx/html/
