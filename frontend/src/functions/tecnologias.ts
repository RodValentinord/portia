import { Tecnologia } from "@core";
import { httpGet } from "./api";

export async function obterTecnologias() {
	const resposta = await httpGet("tecnologias");

	console.log("🔍 Resposta da API de tecnologias:", resposta);

	// Corrige: garante que tecnologias seja sempre um array
	const tecnologias: Tecnologia[] = Array.isArray(resposta)
		? resposta
		: resposta?.data ?? [];

	return {
		todas: tecnologias,
		get destaques() {
			return tecnologias.filter((tecnologia) => tecnologia.destaque);
		},
	};
}
