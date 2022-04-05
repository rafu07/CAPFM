namespace SAP.Foldersmanagement;

using { cuid } from '@sap/cds/common';

entity Vergaben {

        //Vergabegrunddaten

    key CASE_GUID              : UUID; //Technischer Schlüssel des Falles (Fall-GUID)
    key MANDT                  : Decimal(3, 0); //Mandant
        PS_SUBJECT             : String; //Fallbetreff
        PS_ACTIVE_TEND         : Timestamp; //Laufzeitende
        PS_ACTIVE_TSTART       : Timestamp; // Laufzeitanfang
        BUKBRS                 : String; //Buchungkreis
        EKGRP                  : Decimal(4, 0); //Einkäufergruppe
        EKORG                  : Decimal(4, 0); //Einkaufsorganisation
        PS_DISPOSALSTATE       : String; //Aussonderungsstatus

        //Vergabekondiitonen

        WAERS_ALLOC            : String; //Vergabewährung
        MWSKZ                  : String; //Umsatzsteuerkennzeichen
        WAERS_LC               : String; //Hauswährung
        UKURS_CURR             : Decimal(8, 2); //Kurs
        COSTCE_PRORE_IOPT_ETAX : Decimal; //Kostendach beschaffungsrelevant inkl. Optionen (exkl. MwSt.)
        TOTALCOST_NOPRORE_ITAX : Decimal; //Kosten nicht Beschaffungsrelevant inkl. MwSt.


        //Beschaffungskonditionen

        LEGAL_SCOPE            : String; //rechtlicher Anwendungsbereich
        PROC_COMPETENCE        : String; //Beschaffungskompetenz
        PROC_PROC              : String; //Beschaffungsverfahren
        DEL_ID                 : Integer; //DelegationsID

        //Associations        
        volumenpositionen: Association to many VOLUMENPOSITIONEN on volumenpositionen.VERGABEAKTE = $self;

}


entity VOLUMENPOSITIONEN {
    key Dokumentennummer : String;
    vergabeAttr1 : String;
    vergabeAttr2: String;
    vergabeAttr3: String;

    VERGABEAKTE: Association to Vergaben;
    bestellanforderung: Association to many BANF on bestellanforderung.VOLUMENPOSITION= $self;
    kontrakte: Association to many Contract on kontrakte.VOLUMENPOSITION = $self;
}

entity BANF : cuid {

//Entitynamen im Frontend gleich

SAP_Description: String;
Kurzbeschreibung: String; 
Warengruppe: String;
Material: String;
Lieferantenmaterialnummer: String;
Bewertungspreis: Decimal;
Preiseinheit: String;
Anforderungsmenge: Decimal;
Lieferdatum: String;
Produkttypgruppe: String;
Status: StatusType;
VOLUMENPOSITION : Association to VOLUMENPOSITIONEN;


}

entity Contract : cuid {

Beschreibung : String;
Kontraktart: Kontraktart;
Lieferant: String;
Waehrung: Waherung;
GueltigVon : Date;
GueltigBis : Date;
Auslaufdatum : Date;
EKGRP : String;
EKORG : String;
BUKRS    : String; //Buchungkreis
Angelegtam : Date;
Genehmigender : String;
Zielwert : Decimal;
Umrechnungskurs : Decimal;
FixierterKurs: Decimal;
Zahlungsbed: String;
ErsteZahlungInTagen: Integer;
SkontoErsteZahlung: Integer;
ZweiteZahlungInTagen: Integer;
SkontoZweiteZahlung: Integer;
Skontotage: Integer;
Angebotsdatum: Date;
Angebot: String;
IhrZeichen: String;
UnserZeichen: String;
Verkauefer: String;
Rechungssteller: String;
VOLUMENPOSITION : Association to VOLUMENPOSITIONEN;


}


type Waherung : String enum{
EUR;
USD;
YAN
}

type Kontraktart : String enum {
    WK;
    MK
}

type StatusType : String enum {
    genehmigt;
    ausstehend;
};

type WarengruppenType : String enum {
    Monitor;
    Laptop;
    Tastatur;
}
