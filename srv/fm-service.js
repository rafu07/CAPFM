const dayjs = require('dayjs'),
cds = require("@sap/cds");


module.exports = async (srv) => {

    const db = await cds.connect.to ('db')
    const {BANF, Vergaben, Contract, VOLUMENPOSITIONEN  } = srv.entities;
    const images = {
        monitor : 'sap-icon://sys-monitor',
        laptop : 'sap-icon://laptop',
        tastatur : 'sap-icon://keyboard-and-mouse'
    }

    const images2 = {
        mk : 'sap-icon://compare',
        wk : 'sap-icon://lead',
    }

    srv.after(['READ', 'EDIT', 'SAVE'], Contract, async (response, req) => {
        response = Array.isArray(response) ? response : [response];
        for(let contract of response) {
            contract = setDates(contract)
            contract.imageURL = setImageURL(contract)
        }
    });

    srv.after(['READ', 'EDIT', 'SAVE'], VOLUMENPOSITIONEN, async (response, req) => {
        response = Array.isArray(response) ? response : [response];
        for(let volumenposition of response) {
            volumenposition = await setCreatedContractCount(volumenposition)
        }
    });

    srv.after(['READ', 'EDIT', 'SAVE'], BANF, async (response, req) => {
        response = Array.isArray(response) ? response : [response];
        console.log("in banf handler")
        for(let banf of response) {
            banf = addCriticality(banf)
            banf.imageURL = addImageUrl(banf)
            console.log(response === undefined ? 'yes' : 'no')
            banf = calculateGesamtpreis(banf)
        }
    });

    async function setCreatedContractCount(response){
        console.log("bin da")
        const data = await SELECT(Contract) 
        response.contractCount = data.length
        return response;
    }


    function setImageURL({Kontraktart}){
        return Kontraktart === 'WK' ? images2.wk : images2.mk ;
    }

    function setDates(response){
        response.GueltigVon = dayjs(new Date()).format('YYYY-MM-DD')
        response.GueltigBis = dayjs(new Date()+ 365).format('YYYY-MM-DD')
        response.Auslaufdatum = dayjs(new Date()+ 365).format('YYYY-MM-DD')
        response.Angelegtam = dayjs(new Date()).format('YYYY-MM-DD')
        response.Angebotsdatum = dayjs(new Date() - 20).format('YYYY-MM-DD')
        return response
    }


    function calculateGesamtpreis(response) {
        const gesamtPreis = response.Bewertungspreis * response.Anforderungsmenge
        response.gesamtPreis = ""+ gesamtPreis.toString() + " (Euro)"  
    }


    function addImageUrl({warengruppe}){
        switch(warengruppe){
            case 'Monitor': 
                return images.monitor
            case 'Tastatur': 
                return images.tastatur
            case 'Laptop':
                return images.laptop
        }
    }

    function addCriticality(delta = 2){
        response.Lieferdatum = dayjs(new Date()- 2).format('YYYY-MM-DD');
        if( delta < 7 ){
            response.criticalityDate = 2; 
        } 
        else if(delta < 10 ){
            response.criticalityDate = 1; 
        }
        else {
            response.criticalityDate = 0; 
        }
        return response;
    }

    srv.on("toggleState",BANF, async (req) => {
        console.log(req.params[1]);
        let status = (await SELECT.one.from(BANF, ID => req.params[1])).Status
        
        status = status === 'genehmigt' ? 'ausstehend' : 'genehmigt';
        return await UPDATE(BANF, req.params[1]).with({Status : status})
    });

}