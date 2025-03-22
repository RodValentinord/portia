import { Controller, Get } from '@nestjs/common';
import { Tecnologia } from '@core';
import { TecnologiaProvider } from './tecnologia.provider';

@Controller('tecnologias')
export class TecnologiaController {

    constructor(private readonly repo: TecnologiaProvider){}
    @Get()
    async obterTodas(): Promise<Tecnologia[]>{
        return this.repo.obterTodas()
    }

    @Get("destaques")
    async obterDestaques(): Promise<Tecnologia[]>{
        return this.repo.obterDestaques()
    }
}
