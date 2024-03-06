import { Client } from 'pg';

export interface Env {
	DB_URL: string;
}

export default {
	async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
		const client = new Client(env.DB_URL);
		await client.connect();
		const start = Date.now();
		const result = await client.query('SELECT * FROM products');
		const end = Date.now();
		ctx.waitUntil(client.end());
		const rows = result.rows.map((row: any) => {
			return { id: row.id, name: row.name };
		});
		const queryTime = (end - start) / 1000;
		return new Response(JSON.stringify({ queryTime, rows }), {
			headers: { 'Content-Type': 'application/json' },
		});
	},
};
