# The 100 ms Data Access Challenge

Can we use Cloudflare Workers and pgEdge to achieve <100 ms data access from
anywhere in the US and Europe?

See the corresponding blog post on [pgedge.com/blog](https://www.pgedge.com/blog).

## Technical Overview

- Deploy a free 3-node pgEdge PostgreSQL cluster [here](https://app.pgedge.com/).
- Deploy the Cloudflare Worker in this repository.
- Create a Cloudflare Hyperdrive associated with the pgEdge database and use
  this in the Cloudflare Worker.
- Test request latencies from across the US and Europe by deploying VMs in
  multiple Google Cloud regions and then running the [cmd/measure-latency](cmd/measure-latency)
  tool to determine average latencies.

## Prerequisites

If you want to deploy and run this all yourself, you'll need the following:

- `npm` and `npx` installed
- Cloudflare account (free or $5/month Workers paid plan)
- pgEdge account (free Developer Edition plan)
- Terraform and Google Cloud (for measuring latencies)

## Cloudflare Request Headers

Just for reference. You can grab the client's location information from the
Cloudflare request.

```javascript
function getCloudflareInfo(request: Request) {
  const cf = request.cf || {};
  return {
    latitude: cf.latitude,
    longitude: cf.longitude,
    country: cf.country,
    city: cf.city,
    colo: cf.colo,
    timezone: cf.timezone,
    region: cf.region,
  };
}
```
