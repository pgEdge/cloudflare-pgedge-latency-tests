# Cloudflare to pgEdge Latency Tests

Example application and test suite for measuring the latency of data access
requests from Cloudflare Workers to pgEdge distributed PostgreSQL databases.

## The 100 ms Data Access Challenge

Can we use Cloudflare Workers and pgEdge to achieve <100 ms data access for
end-users located anywhere in the US and Europe?

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
