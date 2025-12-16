---
title: Query Form Resource
---
When building APIs that support complex queries, clients often need to submit structured search criteria that must be validated before processing.
Sending invalid query parameters can result in errors or unexpected results, and complex validation logic may require server-side processing.

> # How can an API validate complex query parameters before redirecting clients to execute the actual query?
> Use a Query Form Resource that accepts query parameters in the request body, validates them, and redirects to a Query Resource if valid.

The Query Form Resource acts as a validation gateway that ensures query parameters are properly formatted and contain valid values before the client is redirected to perform the actual search or query operation.

# Sequence Diagram

{% plantuml %}
!theme mars
skinparam NoteFontName Courier

actor Client as client
boundary API as api


alt validation successful
  client -> api++: POST /search-form
  note right
  {
  "filters": {
      "category": "electronics",
      "price_range": {
      "min": 100,
      "max": 500
      },
      "brand": "acme"
  },
  "sort": "price_desc",
  "limit": 20
  }
  endnote
  return 303 See Other
  note left
  Location: /search?category=electronics&price_min=100&price_max=500&brand=acme&sort=price_desc&limit=20
  endnote
  
  client -> api++: GET /search?category=electronics&...
  return 200 OK
  note left
  {
    "results": [...],
    "total": 42,
    "_links": {
      "next": {...},
      "self": {...}
    }
  }
  endnote

else validation failed
  client -> api++: POST /search-form
  note right
  {
  "filters": {
      "category": "electronics",
      "price_range": {
      "min": -20,
      "max": 500
      },
      "brand": "acme"
  },
  "sort": "price_desc",
  "limit": 200
  }
  endnote
  return 400 Bad Request
  note left
  {
    "errors": [
      {
        "field": "price_range.min",
        "message": "Minimum price must be positive"
      },
      {
        "field": "limit", 
        "message": "Limit cannot exceed 100"
      }
    ]
  }
  endnote
end
{% endplantuml %}

# Properties

## Strengths


## Weaknesses

### Additional Round Trip
Requires an extra HTTP request compared to sending query parameters directly to the Query Resource.
