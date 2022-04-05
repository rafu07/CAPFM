using SAP.Foldersmanagement as fm from '../db/data-model';


service FMService {
    entity Vergaben as projection on fm.Vergaben {
        *,
        virtual 0 as gesamtWertVergabe: String
    }

    entity Contract as projection on fm.Contract {
        *,
        virtual 0 as imageURL : String,

    };

    entity VOLUMENPOSITIONEN as projection on fm.VOLUMENPOSITIONEN{
        *,
        virtual 0 as contractCount : String

    };


    entity BANF as projection on fm.BANF   {
        *, 
        virtual 0 as criticalityDate : Integer,
        virtual 0 as imageURL : String,
        virtual 0 as gesamtPreis : String

    } actions {
        @(
            //Update the UI after action
            cds.odata.bindingparameter.name : '_BANF',
            Common.SideEffects              : {
                TargetProperties : ['_BANF/Status']
            }
        )
        action toggleState();
    }
}