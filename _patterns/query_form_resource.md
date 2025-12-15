---
title: Query Form Resource
---
When building APIs that support complex queries, clients often need to submit structured search criteria that must be validated before processing.
Sending invalid query parameters can result in errors or unexpected results, and complex validation logic may require server-side processing.

> # How can an API validate complex query parameters before redirecting clients to execute the actual query?
> Use a Query Form Resource that accepts query parameters in the request body, validates them, and redirects to a Query Resource if valid.

The Query Form Resource acts as a validation gateway that ensures query parameters are properly formatted and contain valid values before the client is redirected to perform the actual search or query operation.

# Sequence Diagram

![Sequence Diagram for the query form resource pattern](query_form_resource.svg)

# Properties

## Strengths


## Weaknesses

### Additional Round Trip
Requires an extra HTTP request compared to sending query parameters directly to the Query Resource.
