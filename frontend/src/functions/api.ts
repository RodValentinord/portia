const baseURL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:3001";

export async function httpGet(endpoint: string) {
	const url = normalizarUrl(`${baseURL}/${endpoint}`);
	console.log("🔗 Fetching:", url);
	const response = await fetch(url);
	return response.json();
}

function normalizarUrl(url: string) {
	const [protocolo, restante] = url.split("://");
	return `${protocolo}://${restante.replaceAll(/\/{2,}/g, "/")}`;
}
