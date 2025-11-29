CREATE DATABASE Biblioteca;
USE Biblioteca;

CREATE TABLE Autore(
	CodiceAutore smallint(2),
	NomeAutore varchar(20) NOT NULL,
	CognomeAutore varchar(20) NOT NULL,
	LuogoDiNascita varchar(20),
	AnnoDiNascita year,
	SessoAutore varchar(1),
	PRIMARY KEY(CodiceAutore)
);

CREATE TABLE Genere(
	NomeGenere varchar(20),
	DescrizioneGenere varchar(300),
	PRIMARY KEY(NomeGenere)
);

CREATE TABLE CasaEditrice(
	NomeCasaEditrice varchar(30),
	Sede varchar(30),
	PRIMARY KEY(NomeCasaEditrice)
);

CREATE TABLE Libro(
	ISBN varchar(13),
	TitoloLibro varchar(200),
	NomeDellaCasaEditrice varchar(30) NOT NULL,
	PRIMARY KEY(ISBN),
	FOREIGN KEY(NomeDellaCasaEditrice)
        REFERENCES CasaEditrice(NomeCasaEditrice)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Scaffale(
	NumeroScaffale smallint(2),
	Piano smallint(1) NOT NULL,
	PRIMARY KEY(NumeroScaffale)
);

CREATE TABLE Copia(
	NumeroCopia smallint(1),
	CodiceISBN varchar(13),
	NumeroDiScaffale smallint(2) NOT NULL,
	Stato varchar(15),
	PRIMARY KEY(NumeroCopia,CodiceISBN,NumeroDiScaffale),
        FOREIGN KEY(CodiceISBN)
        REFERENCES Libro(ISBN)
        ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY(NumeroDiScaffale)
        REFERENCES Scaffale(NumeroScaffale)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Lettore(
	CodiceLettore smallint(3),
	NomeLettore varchar(20) NOT NULL,
	CognomeLettore varchar(20) NOT NULL,
	Email varchar(40),
	SessoLettore varchar(1),
	Via varchar(30),
	CAP varchar(5),
	NumeroCivico smallint(3),
	PRIMARY KEY(CodiceLettore)
);

CREATE TABLE Valutazione(
	CodiceValutazione smallint(3),
	Descrizione varchar(100) NOT NULL,
	CodiceDelLettore smallint(3) NOT NULL,
	PRIMARY KEY(CodiceValutazione),
	FOREIGN KEY(CodiceDelLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Ricercatore(
	CodiceRicercatore smallint(3),
	CodiceDelLettore smallint(3),
	Categoria varchar(30),
	PRIMARY KEY(CodiceRicercatore,CodiceDelLettore),
	FOREIGN KEY(CodiceDelLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Docente(
	CodiceDocente smallint(3),
	CodiceDelLettore smallint(3),
	Tipologia varchar(30),
	PRIMARY KEY(CodiceDocente,CodiceDelLettore),
	FOREIGN KEY(CodiceDelLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Dottorando(
	CodiceDottorando smallint(3),
	CodiceDelLettore smallint(3),
	CorsoDottorando varchar(30) NOT NULL,
	AnnoIscrizioneDottorando year,
	AnnoLaurea year,
	CodiceDelDocente smallint(3),
	PRIMARY KEY(CodiceDottorando,CodiceDelLettore),
	FOREIGN KEY(CodiceDelLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceDelDocente)
        REFERENCES Docente(CodiceDocente)
        ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT chk_Dottorando CHECK(AnnoIscrizioneDottorando<AnnoLaurea)
);

CREATE TABLE Studente(
	CodiceStudente smallint(3),
	CodiceDelLettore smallint(3),
	AnnoIscrizioneStudente year,
	CorsoStudente varchar(50) NOT NULL,
	MatricolaStudente varchar(8) NOT NULL,
	PRIMARY KEY(CodiceStudente,CodiceDelLettore),
	FOREIGN KEY(CodiceDelLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Scrittura(
	CodiceDiAutore smallint(2),
	CodiceISBNLibro varchar(13),
	PRIMARY KEY(CodiceDiAutore,CodiceISBNLibro),
	FOREIGN KEY(CodiceDiAutore)
        REFERENCES Autore(CodiceAutore)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceISBNLibro)
        REFERENCES Libro(ISBN)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Possesso(
	NomeDiGenere varchar(20),
	CodiceISBNLibro varchar(13),
	Primary Key(NomeDiGenere,CodiceISBNLibro),
	FOREIGN KEY(NomeDiGenere)
        REFERENCES Genere(NomeGenere)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceISBNLibro)
        REFERENCES Libro(ISBN)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Prelevamento(
	NumeroDiCopia smallint(1),
	CodiceISBNLibro varchar(13),
	NumeroDelloScaffale smallint(2),
	CodiceDiLettore smallint(3),
	DataInizioPrestito date NOT NULL,
	PRIMARY KEY(NumeroDiCopia,CodiceISBNLibro,NumeroDelloScaffale,CodiceDiLettore),
	FOREIGN KEY(NumeroDiCopia)
        REFERENCES Copia(NumeroCopia)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceISBNLibro)
        REFERENCES Libro(ISBN)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(NumeroDelloScaffale)
        REFERENCES Scaffale(NumeroScaffale)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceDiLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Restituzione(
	NumeroDiCopia smallint(1),
	CodiceISBNLibro varchar(13),
	NumeroDelloScaffale smallint(2),
	CodiceDiLettore smallint(3),
	DataFinePrestito date NOT NULL,
	PRIMARY KEY(NumeroDiCopia,CodiceISBNLibro,NumeroDelloScaffale,CodiceDiLettore),
	FOREIGN KEY(NumeroDiCopia)
        REFERENCES Copia(NumeroCopia)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceISBNLibro)
        REFERENCES Libro(ISBN)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(NumeroDelloScaffale)
        REFERENCES Scaffale(NumeroScaffale)
        ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CodiceDiLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Composizione(
	CodiceValutazioneLettore smallint(3),
	CodiceDiLettore smallint(3),
	DataValutazione date NOT NULL,
	PRIMARY KEY(CodiceValutazioneLettore,CodiceDiLettore),
	FOREIGN KEY(CodiceValutazioneLettore)
        REFERENCES Valutazione(CodiceValutazione)
        ON UPDATE CASCADE ON DELETE CASCADE,
 	FOREIGN KEY(CodiceDiLettore)
        REFERENCES Lettore(CodiceLettore)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO Autore VALUES(1,'Marco','Boella','Italia',1970,'M');
INSERT INTO Autore VALUES(2,'Hal Ronald','Varian','Stati Uniti',1947,'M');
INSERT INTO Autore VALUES(3,'Gian Franco','Campobasso','Italia',1942,'M');
INSERT INTO Autore VALUES(4,'Renato','Barboni','Italia',1940,'M');
INSERT INTO Autore VALUES(5,'Renzo','Perfetti','Italia',1958,'M');
INSERT INTO Autore VALUES(6,'William','Stallings','Stati Uniti',1945,'M');
INSERT INTO Autore VALUES(7,'Andrew Stuart','Tanenbaum','Stati Uniti',1944,'M');
INSERT INTO Autore VALUES(8,'Giovanni','Marro','Italia',1958,'M');
INSERT INTO Autore VALUES(9,'Giacomo','Corna Pellegrini','Italia',1931,'M');
INSERT INTO Autore VALUES(10,'Giulio','Guidorizzi','Italia',1948,'M');
INSERT INTO Autore VALUES(11,'George','Orwell','Regno Unito',1903,'M');
INSERT INTO Autore VALUES(12,'Andrea','Camilleri','Italia',1925,'M');
INSERT INTO Autore VALUES(13,'Giulia','Belgioioso','Italia',1947,'F');
INSERT INTO Autore VALUES(14,'Mario','De Micheli','Italia',1914,'M');
INSERT INTO Autore VALUES(15,'Ray','Jackendoff','Stati Uniti',1945,'M');
INSERT INTO Autore VALUES(16,'Mario','Liverani','Italia',1939,'M');
INSERT INTO Autore VALUES(17,'Agnese','Manca','Italia',1945,'F');
INSERT INTO Autore VALUES(18,'Mitchell','Hall','Stati Uniti',1955,'M');
INSERT INTO Autore VALUES(19,'Giorgio','Del Zanna','Italia',1971,'M');
INSERT INTO Autore VALUES(20,'Enrica','Collotti Pischel','Italia',1930,'F');
INSERT INTO Autore VALUES(21,'Maria Valeria','Catani','Italia',1965,'F');
INSERT INTO Autore VALUES(22,'Alberto','Cei','Italia','1955','M');
INSERT INTO Autore VALUES(23,'Kenneth','Saladin','Stati Uniti','1949','M');
INSERT INTO Autore VALUES(24,'Angelo','Maietta','Italia',1973,'M');
INSERT INTO Autore VALUES(25,'Daniel','Kahneman','Israele',1934,'M');
INSERT INTO Autore VALUES(26,'Neil','Carlson','Stati Uniti',1942,'M');
INSERT INTO Autore VALUES(27,'Pierpaolo','Donati','Italia',1946,'M');
INSERT INTO Autore VALUES(28,'Sergio','Tramma','Italia',1948,'M');
INSERT INTO Autore VALUES(29,'Annamaria','Campanini','Italia',1950,'F');
INSERT INTO Autore VALUES(30,'Luigi','Prestinenza Puglisi','Italia',1956,'M');
INSERT INTO Autore VALUES(31,'Carlo','Gasparrini','Italia',1955,'M');
INSERT INTO Autore VALUES(32,'Eugenio','Arbizzani','Italia',1958,'M');
INSERT INTO Autore VALUES(33,'Andrea','Benedetto','Italia',1968,'M');
INSERT INTO Autore VALUES(34,'Massimo','Paradiso','Italia',1949,'M');
INSERT INTO Autore VALUES(35,'Salvatore','Curreri','Italia',1962,'M');
INSERT INTO Autore VALUES(36,'Franco Gaetano','Scoca','Italia',1958,'M');
INSERT INTO Autore VALUES(37,'Frederick','Schauer','Stati Uniti',1946,'M');
INSERT INTO Autore VALUES(38,'Paul','Newbold','Regno Unito',1945,'M');
INSERT INTO Autore VALUES(39,'Peter','Russell','Regno Unito',1921,'M');
INSERT INTO Autore VALUES(40,'Leslie','Gartner','Stati Uniti',1943,'M');
INSERT INTO Autore VALUES(41,'Jerome','Bruner','Stati Uniti',1915,'M');
INSERT INTO Autore VALUES(42,'Giovanni','Genovesi','Italia',1941,'M');
INSERT INTO Autore VALUES(43,'Giovanbattista','Amenta','Italia',1963,'M');
INSERT INTO Autore VALUES(44,'Alessandro','Bertirotti','Italia',1964,'M');
INSERT INTO Autore VALUES(45,'Giuseppe','De Arcangelis','Italia',1962,'M');
INSERT INTO Autore VALUES(46,'Simon','Benninga','Olanda',1947,'M');
INSERT INTO Autore VALUES(47,'Guy','Deutscher','Israele',1969,'M');
INSERT INTO Autore VALUES(48,'Francesco','Rovetto','Italia',1948,'M');
INSERT INTO Autore VALUES(49,'Patrizia','Patrizi','Italia',1957,'F');
INSERT INTO Autore VALUES(50,'Andrea','Lenzi','Italia',1953,'M');
INSERT INTO Autore VALUES(51,'Gianni','De Luca','Italia',1927,'M');
INSERT INTO Autore VALUES(52,'Carolyn','Dittmeier','Stati Uniti',1956,'F');
INSERT INTO Autore VALUES(53,'Vincenzo','Fasone','Italia',1981,'M');
INSERT INTO Autore VALUES(54,'Roberto','D’Apostoli','Italia',1939,'M');
INSERT INTO Autore VALUES(55,'Fabio','Bagarello','Italia',1964,'M');
INSERT INTO Autore VALUES(56,'Renato','Lancellotta','Italia',1949,'M');
INSERT INTO Autore VALUES(57,'Carlo','Viggiani','Italia',1936,'M');
INSERT INTO Autore VALUES(58,'Ugo','Tomasicchio','Italia',1983,'M');
INSERT INTO Autore VALUES(59,'Norman','Myers','Regno Unito',1934,'M');
INSERT INTO Autore VALUES(60,'Chiara','Giaccardi','Italia',1959,'F');

INSERT INTO Genere VALUES('Matematica','Tratta argomenti di ambito matematico, come lo studio di funzioni e le differenti tipologie di equazioni e disequazioni');
INSERT INTO Genere VALUES('Economia','Tratta argomenti di ambito economico, come la gestione delle risorse ed il loro utilizzo per il bene della collettività');
INSERT INTO Genere VALUES('Diritto','Tratta argomenti legati all’ambito del diritto, come il diritto civile, penale e le proprie caratteristiche e procedure');
INSERT INTO Genere VALUES('Fisica','Tratta argomenti di ambito scientifico e studia, in particolare, i fenomeni naturali');
INSERT INTO Genere VALUES('Elettrotecnica','Tratta argomenti relativi all’ambito dell’elettrotecnica, come la produzione, trasmissione e distribuzione di energia elettrica');
INSERT INTO Genere VALUES('Informatica','Tratta argomenti di ambito informatico, come i linguaggi di programmazione, le caratteristiche hardware e software dei computer e le basi di dati');
INSERT INTO Genere VALUES('Geografia','Tratta argomenti relative all’ambito della geografia, come le caratteristiche della terra e dei suoi paesi');
INSERT INTO Genere VALUES('Lettere','Tratta argomenti di ambito letterario, come la letteratura classica, medievale, moderna e contemporanea');
INSERT INTO Genere VALUES('Biografia','Tratta di generi in cui il nucleo del romanzo è rappresentato dalla vita del protagonista');
INSERT INTO Genere VALUES('Rosa','Tratta vicende il cui elemento centrale della trama è una storia d amore');
INSERT INTO Genere VALUES('Giallo','Tratta vicende la cui trama viene creata dall’autore e ruota intorno a un mistero criminale');
INSERT INTO Genere VALUES('Fantascienza','Tratta vicende non esistenti nella realtà e non spiegabile razionalmente');
INSERT INTO Genere VALUES('Filosofia','Tratta argomenti di ambito filosofico, come le varie epoche filosofiche con i relativi autori');
INSERT INTO Genere VALUES('Arte','Tratta argomenti di ambito artistico, come le varie epoche artistiche con i relativi autori');
INSERT INTO Genere VALUES('Lingue','Tratta argomenti di ambito linguistico, come la storia ed i vari tipi di linguaggi umani');
INSERT INTO Genere VALUES('Archeologia','Tratta argomenti riguardanti l’ambito dell’archeologia, come lo studio delle civiltà e culture umane del passato');
INSERT INTO Genere VALUES('Storia','Tratta argomenti riguardanti l’ambito della storia, come i più importanti avvenimenti della storia dell’umanità');
INSERT INTO Genere VALUES('Medicina','Tratta argomenti di ambito medico, come le branche della medicina, le patologie umane e le relative cure');
INSERT INTO Genere VALUES('Sociologia','Tratta argomenti di ambito sociale, come lo studio dei fatti sociali considerati costanti nelle loro caratteristiche e nei loro processi');
INSERT INTO Genere VALUES('Architettura','Tratta argomenti dell’ambito architetturale, come la progettazione e la creazione di un immobile o dell’ambiente costruito');
INSERT INTO Genere VALUES('Pedagogia','Tratta argomenti di ambito educativo, come l’educazione e la formazione dell’essere umano nel suo intero ciclo di vita');
INSERT INTO Genere VALUES('Ingegneria civile','Tratta argomenti dell’ambito relativo all’ingegneria civile, come geotecnica, idraulica, infrastrutture, trasporti e strutture');

INSERT INTO CasaEditrice VALUES('Pearson','Londra');
INSERT INTO CasaEditrice VALUES('Libreria Editrice Cafoscarina','Venezia'); 
INSERT INTO CasaEditrice VALUES('UTET','Torino');   
INSERT INTO CasaEditrice VALUES('Scione Editore','Roma');
INSERT INTO CasaEditrice VALUES('Zanichelli','Bologna');
INSERT INTO CasaEditrice VALUES('McGraw Hill','New York');
INSERT INTO CasaEditrice VALUES('Carocci','Roma');
INSERT INTO CasaEditrice VALUES('Mondadori','Milano'); 
INSERT INTO CasaEditrice VALUES('Salerno','Roma');   
INSERT INTO CasaEditrice VALUES('Sellerio','Palermo');
INSERT INTO CasaEditrice VALUES('Feltrinelli','Milano');
INSERT INTO CasaEditrice VALUES('Rizzoli','Segrate');
INSERT INTO CasaEditrice VALUES('Il Mulino','Bologna');
INSERT INTO CasaEditrice VALUES('Laterza','Bari');
INSERT INTO CasaEditrice VALUES('Herder','Friburgo');
INSERT INTO CasaEditrice VALUES('Piccin','Padova');
INSERT INTO CasaEditrice VALUES('Giappichelli','Torino');
INSERT INTO CasaEditrice VALUES('Sossella','Bologna');
INSERT INTO CasaEditrice VALUES('Etas','Milano');
INSERT INTO CasaEditrice VALUES('Maggioli','Santarcangelo di Romagna');
INSERT INTO CasaEditrice VALUES('FrancoAngeli','Milano');
INSERT INTO CasaEditrice VALUES('Edises','Napoli');
INSERT INTO CasaEditrice VALUES('La scuola','Brescia');
INSERT INTO CasaEditrice VALUES('Pensa multimedia','Lecce');
INSERT INTO CasaEditrice VALUES('Firenze university press','Firenze');
INSERT INTO CasaEditrice VALUES('Bollati boringhieri','Torino');
INSERT INTO CasaEditrice VALUES('Elsevier','Amsterdam');
INSERT INTO CasaEditrice VALUES('Egea','Milano');
INSERT INTO CasaEditrice VALUES('Edizioni Simone','Napoli');
INSERT INTO CasaEditrice VALUES('Aracne','Roma');
INSERT INTO CasaEditrice VALUES('Hevelius','Benevento');
INSERT INTO CasaEditrice VALUES('Hoepli','Milano');
INSERT INTO CasaEditrice VALUES('Edizioni ambiente','Milano');

INSERT INTO Libro VALUES(9788871927695,'Analisi matematica 1 e algebra lineare','Pearson');
INSERT INTO Libro VALUES(9788875433079,'Microeconomia','Libreria Editrice Cafoscarina');
INSERT INTO Libro VALUES(9788859814863,'Manuale di diritto commerciale','UTET');
INSERT INTO Libro VALUES(9788864510316,'Fondamenti di aerospaziale','Scione Editore');
INSERT INTO Libro VALUES(9788808178886,'Circuiti elettrici','Zanichelli');
INSERT INTO Libro VALUES(9788838663772,'Crittografia e sicurezza delle reti','McGraw Hill');
INSERT INTO Libro VALUES(9788891908254,'Reti di calcolatori','Pearson');
INSERT INTO Libro VALUES(9788808055750,'Controlli Automatici','Zanichelli');
INSERT INTO Libro VALUES(9788843042463,'Geografia diversa e preziosa. Il pensiero geografico in altri saperi umani','Carocci');
INSERT INTO Libro VALUES(9788861847040,'Letteratura greca: da Omero al secolo VI d.C.','Mondadori');
INSERT INTO Libro VALUES(9788804668237,'1984','Mondadori');
INSERT INTO Libro VALUES(9788838910173,'La forma dell’acqua','Sellerio');
INSERT INTO Libro VALUES(9788804716372,'Km 123','Mondadori');
INSERT INTO Libro VALUES(9788800747752,'Storia della filosofia moderna','Mondadori');
INSERT INTO Libro VALUES(9788807884092,'Le avanguardie artistiche del Novecento','Feltrinelli');
INSERT INTO Libro VALUES(9788815067180,'Linguaggio e natura umana','Il Mulino');
INSERT INTO Libro VALUES(9788842095880,'Antico oriente','Laterza');
INSERT INTO Libro VALUES(9788889670132,'Grammatica teorico pratica di arabo letterario moderno','Herder');
INSERT INTO Libro VALUES(9788815121264,'La guerra del Vietnam','Il Mulino');
INSERT INTO Libro VALUES(9788815244123,'La fine dell’impero ottomano','Il Mulino');
INSERT INTO Libro VALUES(9788843029886,'Storia dell’Asia orientale','Carocci');
INSERT INTO Libro VALUES(9788829928437,'Appunti di biochimica per le lauree triennali','Piccin');
INSERT INTO Libro VALUES(9788815067098,'Psicologia dello sport','Il Mulino');
INSERT INTO Libro VALUES(9788829920860,'Anatomia umana','Piccin');
INSERT INTO Libro VALUES(9788892103023,'Lineamenti di diritto dello sport','Giappichelli');
INSERT INTO Libro VALUES(9788804671954,'Pensieri lenti e veloci','Mondadori');
INSERT INTO Libro VALUES(9788829923175,'Fisiologia del comportamento','Piccin');
INSERT INTO Libro VALUES(9788842079491,'Manuale di sociologia della famiglia','Laterza');
INSERT INTO Libro VALUES(9788848200465,'L’educazione sociale','Laterza');
INSERT INTO Libro VALUES(9788874667543,'Gli ambiti di intervento del servizio sociale','Carocci');
INSERT INTO Libro VALUES(9788897356974,'La storia dell’architettura 1905-2018','Sossella');
INSERT INTO Libro VALUES(9788845306631,'L’attualità dell’urbanistica','Etas');
INSERT INTO Libro VALUES(9788891612861,'Tecnica e tecnologia dei sistemi edilizi','Maggioli');
INSERT INTO Libro VALUES(9788860084613,'Strade, ferrovie, aeroporti','UTET');
INSERT INTO Libro VALUES(9788834828762,'Corso di istituzioni di diritto privato','Giappichelli');
INSERT INTO Libro VALUES(9788891778604,'Lezioni sui diritti fondamentali','FrancoAngeli');
INSERT INTO Libro VALUES(9788834879474,'Diritto amministrativo','Giappichelli');
INSERT INTO Libro VALUES(9788892136694,'Giustizia amministrativa','Giappichelli');
INSERT INTO Libro VALUES(9788843084784,'Il ragionamento giuridico. Una nuova introduzione','Carocci');
INSERT INTO Libro VALUES(9788871926049,'Statistica','Pearson');
INSERT INTO Libro VALUES(9788879593854,'Genetica','Edises');
INSERT INTO Libro VALUES(9788879594837,'Istologia','Edises');
INSERT INTO Libro VALUES(9788807886515,'La cultura dell’educazione','Feltrinelli');
INSERT INTO Libro VALUES(9788842094777,'Storia della scuola in Italia dal Settecento a oggi','Laterza');
INSERT INTO Libro VALUES(9788867601592,'Docimologia e ricerca educativa','Pensa multimedia');
INSERT INTO Libro VALUES(9788835023289,'L’osservazione dei processi d’apprendimento','La scuola');
INSERT INTO Libro VALUES(9788884530738,'L’uomo, il suono e la musica','Firenze university press');
INSERT INTO Libro VALUES(9788838675508,'Economia internazionale','McGraw Hill');
INSERT INTO Libro VALUES(9788838666377,'Modelli finanziari. La finanza con Excel','McGraw Hill');
INSERT INTO Libro VALUES(9788833923390,'La lingua colora il mondo. Come le parole deformano la realtà','Bollati boringhieri');
INSERT INTO Libro VALUES(9788891710796,'Psicologia clinica, psichiatria, psicofarmacologia. Uno spazio d’intergrazione','FrancoAngeli');
INSERT INTO Libro VALUES(9788843060368,'Psicologia della devianza e della criminalità. Teorie e modelli di intervento','Carocci');
INSERT INTO Libro VALUES(9788821429996,'Endocrinologia e attività motorie','Elsevier');
INSERT INTO Libro VALUES(9788891414540,'Manuale di contabilità di Stato e degli enti','Edizioni Simone');
INSERT INTO Libro VALUES(9788823834262,'La governance dei rischi. Un riferimento per gli organi e le funzioni di governo e controllo','Egea');
INSERT INTO Libro VALUES(9788854859319,'Elementi di analisi dei costi','Aracne');
INSERT INTO Libro VALUES(9788838748455,'Prontuario di topografia professionale','Maggioli');
INSERT INTO Libro VALUES(9788838672958,'Meccanica razionale per l’ingegneria','McGraw Hill');
INSERT INTO Libro VALUES(9788808059918,'Geotecnica','Zanichelli');
INSERT INTO Libro VALUES(9788886977128,'Fondazioni','Hevelius');
INSERT INTO Libro VALUES(9788820346430,'Manuale di ingegneria portuale e costiera','Hoepli');
INSERT INTO Libro VALUES(9788886412629,'Esodo ambientale','Edizioni ambiente');
INSERT INTO Libro VALUES(9788815239334,'La comunicazione interculturale nell’era digitale','Il Mulino');

INSERT INTO Scaffale VALUES(1,1);
INSERT INTO Scaffale VALUES(2,1);
INSERT INTO Scaffale VALUES(3,1);
INSERT INTO Scaffale VALUES(4,1);
INSERT INTO Scaffale VALUES(5,1);
INSERT INTO Scaffale VALUES(6,2);
INSERT INTO Scaffale VALUES(7,2);
INSERT INTO Scaffale VALUES(8,2);
INSERT INTO Scaffale VALUES(9,2);
INSERT INTO Scaffale VALUES(10,2);
INSERT INTO Scaffale VALUES(11,3);
INSERT INTO Scaffale VALUES(12,3);
INSERT INTO Scaffale VALUES(13,3);
INSERT INTO Scaffale VALUES(14,3);
INSERT INTO Scaffale VALUES(15,3);

INSERT INTO Copia VALUES(1,9788871927695,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788871927695,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788871927695,11,'Non disponibile');
INSERT INTO Copia VALUES(1,9788875433079,1,'Non disponibile');
INSERT INTO Copia VALUES(2,9788875433079,6,'Non disponibile');
INSERT INTO Copia VALUES(3,9788875433079,11,'Non disponibile');
INSERT INTO Copia VALUES(1,9788859814863,1,'Non disponibile');
INSERT INTO Copia VALUES(2,9788859814863,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788859814863,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788864510316,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788864510316,6,'Non disponibile');
INSERT INTO Copia VALUES(3,9788864510316,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788808178886,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788808178886,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788808178886,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788838663772,1,'Non disponibile');
INSERT INTO Copia VALUES(2,9788838663772,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788838663772,11,'Non disponibile');
INSERT INTO Copia VALUES(1,9788891908254,1,'Non disponibile');
INSERT INTO Copia VALUES(2,9788891908254,6,'Non disponibile');
INSERT INTO Copia VALUES(3,9788891908254,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788808055750,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788808055750,6,'Non disponibile');
INSERT INTO Copia VALUES(3,9788808055750,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788843042463,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788843042463,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788843042463,11,'Non disponibile');
INSERT INTO Copia VALUES(1,9788861847040,1,'Non disponibile');
INSERT INTO Copia VALUES(2,9788861847040,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788861847040,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788804668237,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788804668237,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788804668237,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788838910173,1,'Non disponibile');
INSERT INTO Copia VALUES(2,9788838910173,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788838910173,11,'Non disponibile');
INSERT INTO Copia VALUES(1,9788804716372,2,'Non disponibile');
INSERT INTO Copia VALUES(2,9788804716372,7,'Non disponibile');
INSERT INTO Copia VALUES(3,9788804716372,12,'Non disponibile');
INSERT INTO Copia VALUES(1,9788800747752,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788800747752,7,'Disponibile');
INSERT INTO Copia VALUES(3,9788800747752,12,'Disponibile');
INSERT INTO Copia VALUES(1,9788807884092,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788807884092,7,'Disponibile');
INSERT INTO Copia VALUES(3,9788807884092,12,'Non disponibile');
INSERT INTO Copia VALUES(1,9788815067180,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788815067180,7,'Disponibile');
INSERT INTO Copia VALUES(3,9788815067180,12,'Disponibile');
INSERT INTO Copia VALUES(1,9788842095880,2,'Non disponibile');
INSERT INTO Copia VALUES(2,9788842095880,7,'Non disponibile');
INSERT INTO Copia VALUES(3,9788842095880,12,'Non disponibile');
INSERT INTO Copia VALUES(1,9788889670132,2,'Non disponibile');
INSERT INTO Copia VALUES(2,9788889670132,7,'Disponibile');
INSERT INTO Copia VALUES(3,9788889670132,12,'Disponibile');
INSERT INTO Copia VALUES(1,9788815121264,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788815121264,7,'Disponibile');
INSERT INTO Copia VALUES(3,9788815121264,12,'Disponibile');
INSERT INTO Copia VALUES(1,9788815244123,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788815244123,7,'Disponibile');
INSERT INTO Copia VALUES(3,9788815244123,12,'Non disponibile');
INSERT INTO Copia VALUES(1,9788843029886,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788843029886,7,'Non disponibile');
INSERT INTO Copia VALUES(3,9788843029886,12,'Non disponibile');
INSERT INTO Copia VALUES(1,9788829928437,3,'Disponibile');
INSERT INTO Copia VALUES(2,9788829928437,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788829928437,13,'Disponibile');
INSERT INTO Copia VALUES(1,9788815067098,3,'Disponibile');
INSERT INTO Copia VALUES(2,9788815067098,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788815067098,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788829920860,3,'Disponibile');
INSERT INTO Copia VALUES(2,9788829920860,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788829920860,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788892103023,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788892103023,8,'Non disponibile');
INSERT INTO Copia VALUES(3,9788892103023,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788804671954,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788804671954,8,'Non disponibile');
INSERT INTO Copia VALUES(3,9788804671954,13,'Disponibile');
INSERT INTO Copia VALUES(1,9788829923175,3,'Disponibile');
INSERT INTO Copia VALUES(2,9788829923175,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788829923175,13,'Disponibile');
INSERT INTO Copia VALUES(1,9788842079491,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788842079491,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788842079491,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788848200465,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788848200465,8,'Non disponibile');
INSERT INTO Copia VALUES(3,9788848200465,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788874667543,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788874667543,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788874667543,13,'Disponibile');
INSERT INTO Copia VALUES(1,9788897356974,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788897356974,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788897356974,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788845306631,3,'Disponibile');
INSERT INTO Copia VALUES(2,9788845306631,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788845306631,13,'Non disponibile');
INSERT INTO Copia VALUES(1,9788891612861,3,'Non disponibile');
INSERT INTO Copia VALUES(2,9788891612861,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788891612861,13,'Disponibile');
INSERT INTO Copia VALUES(1,9788860084613,3,'Disponibile');
INSERT INTO Copia VALUES(2,9788860084613,8,'Disponibile');
INSERT INTO Copia VALUES(3,9788860084613,13,'Disponibile');
INSERT INTO Copia VALUES(1,9788834828762,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788834828762,9,'Non disponibile');
INSERT INTO Copia VALUES(3,9788834828762,14,'Disponibile');
INSERT INTO Copia VALUES(1,9788891778604,4,'Non disponibile');
INSERT INTO Copia VALUES(2,9788891778604,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788891778604,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788834879474,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788834879474,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788834879474,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788892136694,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788892136694,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788892136694,14,'Disponibile');
INSERT INTO Copia VALUES(1,9788843084784,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788843084784,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788843084784,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788871926049,4,'Non disponibile');
INSERT INTO Copia VALUES(2,9788871926049,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788871926049,14,'Disponibile');
INSERT INTO Copia VALUES(1,9788879593854,4,'Non disponibile');
INSERT INTO Copia VALUES(2,9788879593854,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788879593854,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788879594837,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788879594837,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788879594837,14,'Disponibile');
INSERT INTO Copia VALUES(1,9788807886515,4,'Non disponibile');
INSERT INTO Copia VALUES(2,9788807886515,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788807886515,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788842094777,4,'Non disponibile');
INSERT INTO Copia VALUES(2,9788842094777,9,'Non disponibile');
INSERT INTO Copia VALUES(3,9788842094777,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788867601592,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788867601592,9,'Non disponibile');
INSERT INTO Copia VALUES(3,9788867601592,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788835023289,4,'Disponibile');
INSERT INTO Copia VALUES(2,9788835023289,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788835023289,14,'Disponibile');
INSERT INTO Copia VALUES(1,9788884530738,4,'Non disponibile');
INSERT INTO Copia VALUES(2,9788884530738,9,'Disponibile');
INSERT INTO Copia VALUES(3,9788884530738,14,'Non disponibile');
INSERT INTO Copia VALUES(1,9788838675508,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788838675508,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788838675508,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788838666377,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788838666377,10,'Non disponibile');
INSERT INTO Copia VALUES(3,9788838666377,15,'Non disponibile');
INSERT INTO Copia VALUES(1,9788833923390,5,'Disponibile');
INSERT INTO Copia VALUES(2,9788833923390,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788833923390,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788891710796,5,'Disponibile');
INSERT INTO Copia VALUES(2,9788891710796,10,'Non disponibile');
INSERT INTO Copia VALUES(3,9788891710796,15,'Non disponibile');
INSERT INTO Copia VALUES(1,9788843060368,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788843060368,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788843060368,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788821429996,5,'Disponibile');
INSERT INTO Copia VALUES(2,9788821429996,10,'Non disponibile');
INSERT INTO Copia VALUES(3,9788821429996,15,'Non disponibile');
INSERT INTO Copia VALUES(1,9788891414540,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788891414540,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788891414540,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788823834262,5,'Disponibile');
INSERT INTO Copia VALUES(2,9788823834262,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788823834262,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788854859319,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788854859319,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788854859319,15,'Non disponibile');
INSERT INTO Copia VALUES(1,9788838748455,5,'Disponibile');
INSERT INTO Copia VALUES(2,9788838748455,10,'Non disponibile');
INSERT INTO Copia VALUES(3,9788838748455,15,'Non disponibile');
INSERT INTO Copia VALUES(1,9788838672958,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788838672958,10,'Non disponibile');
INSERT INTO Copia VALUES(3,9788838672958,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788808059918,5,'Disponibile');
INSERT INTO Copia VALUES(2,9788808059918,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788808059918,15,'Non disponibile');
INSERT INTO Copia VALUES(1,9788886977128,5,'Non disponibile');
INSERT INTO Copia VALUES(2,9788886977128,10,'Disponibile');
INSERT INTO Copia VALUES(3,9788886977128,15,'Disponibile');
INSERT INTO Copia VALUES(1,9788820346430,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788820346430,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788820346430,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788886412629,1,'Disponibile');
INSERT INTO Copia VALUES(2,9788886412629,6,'Disponibile');
INSERT INTO Copia VALUES(3,9788886412629,11,'Disponibile');
INSERT INTO Copia VALUES(1,9788815239334,2,'Disponibile');
INSERT INTO Copia VALUES(2,9788815239334,7,'Non disponibile');
INSERT INTO Copia VALUES(3,9788815239334,12,'Disponibile');

INSERT INTO Lettore VALUES(101,'Giorgia','Ferrari','giorgia.ferrari@unistudent.it','F','Alaimo',60013,14);
INSERT INTO Lettore VALUES(102,'Liberio','Rossi','liberio.rossi@unistudent.it','M','Bernardino Rota',12020,66);
INSERT INTO Lettore VALUES(103,'Cristian','Bianchi','cristian.bianchi@unistudent.it','M','Torricelli',38030,27);
INSERT INTO Lettore VALUES(104,'Alida','Padovano','alida.padovano@unistudent.it','F','Santa Teresa degli Scalzi',90030,10);
INSERT INTO Lettore VALUES(105,'Lucilla','Fanucci','lucilla.fanucci@unistudent.it','F','Bovio',41026,86);
INSERT INTO Lettore VALUES(106,'Edgardo','Verdi','edgardo.verdi@unistudent.it','M','Dante',94100,23);
INSERT INTO Lettore VALUES(107,'Teresa','Palermo','teresa.palermo@unistudent.it','F','Napoleone Colajanni',93100,12);
INSERT INTO Lettore VALUES(108,'Gioele','Verdi','gioele.verdi@unistudent.it','M','Roma',94100,44);
INSERT INTO Lettore VALUES(109,'Mario','Benvenuti','mario.benvenuti@unistudent.it','M','Acrone',15078,39);
INSERT INTO Lettore VALUES(110,'Edoardo','Capon','edoardo.capon@unistudent.it','M','Delle Mura Gianicolensi',81013,59);
INSERT INTO Lettore VALUES(111,'Giovanni','Pisano','giovanni.pisano@unistudent.it','M','Archimede',39040,2);
INSERT INTO Lettore VALUES(112,'Aristide','Genovesi','aristide.genovesi@unistudent.it','M','Gaetano Donizetti',40046,132);
INSERT INTO Lettore VALUES(113,'Fosca','Palermo','fosca.palermo@unistudent.it','F','Delle Viole',60010,105);
INSERT INTO Lettore VALUES(114,'Arcangela','Manfrin','arcangela.manfrin@unistudent.it','F','Francesco Del Giudice',50030,91);
INSERT INTO Lettore VALUES(115,'Cecilia','Bergamaschi','cecilia.bergamaschi@unistudent.it','F','Goffredo Mameli',02030,49);
INSERT INTO Lettore VALUES(116,'Giancarlo','Renzo','giancarlo.renzo@unistudent.it','M','Scala',64029,11);
INSERT INTO Lettore VALUES(117,'Ippolito','Boni','ippolito.boni@unistudent.it','M','Matteo Schilizzi',16154,124);
INSERT INTO Lettore VALUES(118,'Brunilde','Moretti','brunilde.moretti@unistudent.it','F','Nuova agnano',71025,53);
INSERT INTO Lettore VALUES(119,'Christian','Loggia','christian.loggia@unistudent.it','M','Varrone',95020,112);
INSERT INTO Lettore VALUES(120,'Simona','Bianchi','simona.bianchi@unistudent.it','F','Antonio Cecchi',97015,77);
INSERT INTO Lettore VALUES(121,'Paolo','Dante','paolo.dante@unistudent.it','M','Nicolai',13011,54);
INSERT INTO Lettore VALUES(122,'Cristina','Ferrari','cristina.ferrari@unistudent.it','F','Cardinale Riario Sforza',85020,39);
INSERT INTO Lettore VALUES(123,'Iva','Colombo','iva.colombo@unistudent.it','F','Silvio Spaventa',06040,64);
INSERT INTO Lettore VALUES(124,'Mario','Trentino','mario.trentino@unistudent.it','M','Pisanelli',89040,70);
INSERT INTO Lettore VALUES(125,'Marino','Napolitano','marino.napolitano@unistudent.it','M','Nicola Mignogna',85042,138);
INSERT INTO Lettore VALUES(126,'Maria Pia','Barese','mariapia.barese@unistudent.it','F','Adua',80144,123);
INSERT INTO Lettore VALUES(127,'Samuele','Lori','samuele.lori@unistudent.it','M','Firenze',10080,61);
INSERT INTO Lettore VALUES(128,'Dorotea','Lipani','dorotea.lipani@unistudent.it','F','Del Piave',15013,39);
INSERT INTO Lettore VALUES(129,'Lorena','Marco','lorena.marco@unistudent.it','F','Giuseppe Garibaldi',43028,119);
INSERT INTO Lettore VALUES(130,'Luigi','Fiorentini','luigi.fiorentini@unistudent.it','M','Guglielmo Pepe',85020,131);
INSERT INTO Lettore VALUES(131,'Paride','Nucci','paride.nucci@unistudent.it','M','Torricelli',36061,120);
INSERT INTO Lettore VALUES(132,'Roberta','Folliero','roberta.folliero@unistudent.it','F','Giulio Petroni',14034,48);
INSERT INTO Lettore VALUES(133,'Giorgia','Ferrari','giorgia.ferrari@unistudent.it','F','Porta nuova',42035,76);
INSERT INTO Lettore VALUES(134,'Pasquale','Neri','pasquale.neri@unistudent.it','M','Galvani',45012,143);
INSERT INTO Lettore VALUES(135,'Lionella','Verdi','lionella.verdi@unistudent.it','F','Vipacco',07040,93);
INSERT INTO Lettore VALUES(136,'Nunzia','Esposito','nunzia.esposito@unistudent.it','F','Maria Cristina di Savoia',81021,85);
INSERT INTO Lettore VALUES(137,'Cirillo','Piazza','cirillo.piazza@unistudent.it','M','Bernardino Rota',12050,145);
INSERT INTO Lettore VALUES(138,'Mario','Conti','mario.conti@unistudent.it','M','Torre di Mezzavia',66010,13);
INSERT INTO Lettore VALUES(139,'Matilde','Onio','matilde.onio@unistudent.it','F','Genova',43032,149);
INSERT INTO Lettore VALUES(140,'Agnese','Cremonesi','agnese.cremonesi@unistudent.it','F','Silvio Spaventa',06060,142);
INSERT INTO Lettore VALUES(141,'Dora','Verdi','dora.verdi@unistudent.it','F','Belviglieri',36070,24);
INSERT INTO Lettore VALUES(142,'Franco','Mitchell','franco.mitchell@unistudent.it','M','Alessandro Farnese',39050,98);
INSERT INTO Lettore VALUES(143,'Walter','Rizzo','walter.rizzo@unistudent.it','M','Libertà',93100,96);
INSERT INTO Lettore VALUES(144,'Luigi','Fiorentini','luigi.fiorentini@unistudent.it','M','Campi flegrei',43047,6);
INSERT INTO Lettore VALUES(145,'Mario','Piccio','mario.piccio@unistudent.it','M','Del Pontiere',59011,35);
INSERT INTO Lettore VALUES(146,'Benedetto','Lucchesi','benedetto.lucchesi@unistudent.it','M','Callicratide',10078,124);
INSERT INTO Lettore VALUES(147,'Iacopo','Verdi','iacopo.verdi@unistudent.it','M','Torino',11027,8);
INSERT INTO Lettore VALUES(148,'Ornella','George','ornella.george@unistudent.it','F','Antonio Provolo',29020,69);
INSERT INTO Lettore VALUES(149,'Ilaria','Trevisan','italia.trevisan@unistudent.it','F','Longhena',05010,22);
INSERT INTO Lettore VALUES(150,'Franca','Siciliano','franco.siciliano@unistudent.it','F','Tasso',06026,32);

INSERT INTO Valutazione VALUES(201,'Ambiente pulito e spazioso',105);
INSERT INTO Valutazione VALUES(202,'Personale accogliente e gentile',107);
INSERT INTO Valutazione VALUES(203,'Grande, spaziosa e fornita',109);
INSERT INTO Valutazione VALUES(204,'Piccola, angusta e disordinata',113);
INSERT INTO Valutazione VALUES(205,'Piuttosto ordinata e con grandi finestre',120);
INSERT INTO Valutazione VALUES(206,'A misura d’utente ma con un patrimonio non molto ingente',126);
INSERT INTO Valutazione VALUES(207,'Stupenda e come una seconda casa',134);
INSERT INTO Valutazione VALUES(208,'Ottima sia per i libri sia per il sistema d’accesso',139);
INSERT INTO Valutazione VALUES(209,'Catalogo fornito e consultabile online, orario di apertura ampio',142);
INSERT INTO Valutazione VALUES(210,'Materiale bibliotecario consistente e personale disponibile e gentile',147);

INSERT INTO Ricercatore VALUES(250,110,'Scienze fisiche');
INSERT INTO Ricercatore VALUES(251,111,'Scienze matematiche');
INSERT INTO Ricercatore VALUES(252,116,'Scienze dell’informazione');
INSERT INTO Ricercatore VALUES(253,121,'Scienze della terra');
INSERT INTO Ricercatore VALUES(254,124,'Scienze biologiche');
INSERT INTO Ricercatore VALUES(255,132,'Scienze politiche');
INSERT INTO Ricercatore VALUES(256,136,'Scienze storiche');
INSERT INTO Ricercatore VALUES(257,144,'Scienze linguistiche');
INSERT INTO Ricercatore VALUES(258,145,'Scienze filologiche');
INSERT INTO Ricercatore VALUES(259,149,'Scienze letterarie');

INSERT INTO Docente VALUES(260,108,'Ingegneria');
INSERT INTO Docente VALUES(261,114,'Architettura');
INSERT INTO Docente VALUES(262,115,'Medicina');
INSERT INTO Docente VALUES(263,119,'Scienze economiche');
INSERT INTO Docente VALUES(264,122,'Scienze giuridiche');
INSERT INTO Docente VALUES(265,128,'Studi umanistici');
INSERT INTO Docente VALUES(266,129,'Studi sociali');
INSERT INTO Docente VALUES(267,138,'Studi classici');
INSERT INTO Docente VALUES(268,146,'Studi linguistici');
INSERT INTO Docente VALUES(269,148,'Scienze della formazione');

INSERT INTO Dottorando VALUES(270,102,'Scienze umanistiche',2015,2021,265);
INSERT INTO Dottorando VALUES(271,103,'Psicologia clinica',2013,2019,262);
INSERT INTO Dottorando VALUES(272,123,'Giurisprudenza',2014,2020,264);
INSERT INTO Dottorando VALUES(273,135,'Economia e management',2016,2019,263);
INSERT INTO Dottorando VALUES(274,141,'Ingegneria informatica',2017,2020,260);

INSERT INTO Studente VALUES(275,101,2019,'Psicologia',20191826);
INSERT INTO Studente VALUES(276,104,2017,'Lettere',20173144);
INSERT INTO Studente VALUES(277,105,2019,'Psicologia clinica',20191695);
INSERT INTO Studente VALUES(278,106,2015,'Ingegneria informatica',20151824);
INSERT INTO Studente VALUES(279,107,2018,'Ingegneria aerospaziale',20183149);
INSERT INTO Studente VALUES(280,109,2019,'Lettere',20195457);
INSERT INTO Studente VALUES(281,112,2017,'Scienze sociali',20177241);
INSERT INTO Studente VALUES(282,113,2019,'Lingue',20192314);
INSERT INTO Studente VALUES(283,117,2018,'Architettura',20184282);
INSERT INTO Studente VALUES(284,118,2019,'Giurisprudenza',20191415);
INSERT INTO Studente VALUES(285,120,2017,'Giurisprudenza',20179832);
INSERT INTO Studente VALUES(286,125,2016,'Medicina',20162657);
INSERT INTO Studente VALUES(287,126,2019,'Medicina',20191273);
INSERT INTO Studente VALUES(288,127,2015,'Architettura',20157648);
INSERT INTO Studente VALUES(289,130,2017,'Medicina',20176469);
INSERT INTO Studente VALUES(290,131,2016,'Scienze della formazione primaria',20164119);
INSERT INTO Studente VALUES(291,133,2019,'Economia e direzione delle imprese',20193201);
INSERT INTO Studente VALUES(292,134,2019,'Economia aziendale',20194213);
INSERT INTO Studente VALUES(293,137,2019,'Ingegneria civile',20190159);
INSERT INTO Studente VALUES(294,139,2018,'Ingegneria informatica',20182611);
INSERT INTO Studente VALUES(295,140,2016,'Architettura',20163418);
INSERT INTO Studente VALUES(296,142,2015,'Giurisprudenza',20156137);
INSERT INTO Studente VALUES(297,143,2019,'Lingue',20199791);
INSERT INTO Studente VALUES(298,147,2020,'Medicina',20201029);
INSERT INTO Studente VALUES(299,150,2019,'Psicologia',20198425);

INSERT INTO Scrittura VALUES(1,9788871927695);
INSERT INTO Scrittura VALUES(2,9788875433079);
INSERT INTO Scrittura VALUES(3,9788859814863);
INSERT INTO Scrittura VALUES(4,9788864510316);
INSERT INTO Scrittura VALUES(5,9788808178886);
INSERT INTO Scrittura VALUES(6,9788838663772);
INSERT INTO Scrittura VALUES(7,9788891908254);
INSERT INTO Scrittura VALUES(8,9788808055750);
INSERT INTO Scrittura VALUES(9,9788843042463);
INSERT INTO Scrittura VALUES(10,9788861847040);
INSERT INTO Scrittura VALUES(11,9788804668237);
INSERT INTO Scrittura VALUES(12,9788838910173);
INSERT INTO Scrittura VALUES(12,9788804716372);
INSERT INTO Scrittura VALUES(13,9788800747752);
INSERT INTO Scrittura VALUES(14,9788807884092);
INSERT INTO Scrittura VALUES(15,9788815067180);
INSERT INTO Scrittura VALUES(16,9788842095880);
INSERT INTO Scrittura VALUES(17,9788889670132);
INSERT INTO Scrittura VALUES(18,9788815121264);
INSERT INTO Scrittura VALUES(19,9788815244123);
INSERT INTO Scrittura VALUES(20,9788843029886);
INSERT INTO Scrittura VALUES(21,9788829928437);
INSERT INTO Scrittura VALUES(22,9788815067098);
INSERT INTO Scrittura VALUES(23,9788829920860);
INSERT INTO Scrittura VALUES(24,9788892103023);
INSERT INTO Scrittura VALUES(25,9788804671954);
INSERT INTO Scrittura VALUES(26,9788829923175);
INSERT INTO Scrittura VALUES(27,9788842079491);
INSERT INTO Scrittura VALUES(28,9788848200465);
INSERT INTO Scrittura VALUES(29,9788874667543);
INSERT INTO Scrittura VALUES(30,9788897356974);
INSERT INTO Scrittura VALUES(31,9788845306631);
INSERT INTO Scrittura VALUES(32,9788891612861);
INSERT INTO Scrittura VALUES(33,9788860084613);
INSERT INTO Scrittura VALUES(34,9788834828762);
INSERT INTO Scrittura VALUES(35,9788891778604);
INSERT INTO Scrittura VALUES(36,9788834879474);
INSERT INTO Scrittura VALUES(36,9788892136694);
INSERT INTO Scrittura VALUES(37,9788843084784);
INSERT INTO Scrittura VALUES(38,9788871926049);
INSERT INTO Scrittura VALUES(39,9788879593854);
INSERT INTO Scrittura VALUES(40,9788879594837);
INSERT INTO Scrittura VALUES(41,9788807886515);
INSERT INTO Scrittura VALUES(42,9788842094777);
INSERT INTO Scrittura VALUES(43,9788867601592);
INSERT INTO Scrittura VALUES(43,9788835023289);
INSERT INTO Scrittura VALUES(44,9788884530738);
INSERT INTO Scrittura VALUES(45,9788838675508);
INSERT INTO Scrittura VALUES(46,9788838666377);
INSERT INTO Scrittura VALUES(47,9788833923390);
INSERT INTO Scrittura VALUES(48,9788891710796);
INSERT INTO Scrittura VALUES(49,9788843060368);
INSERT INTO Scrittura VALUES(50,9788821429996);
INSERT INTO Scrittura VALUES(51,9788891414540);
INSERT INTO Scrittura VALUES(52,9788823834262);
INSERT INTO Scrittura VALUES(53,9788854859319);
INSERT INTO Scrittura VALUES(54,9788838748455);
INSERT INTO Scrittura VALUES(55,9788838672958);
INSERT INTO Scrittura VALUES(56,9788808059918);
INSERT INTO Scrittura VALUES(57,9788886977128);
INSERT INTO Scrittura VALUES(58,9788820346430);
INSERT INTO Scrittura VALUES(59,9788886412629);
INSERT INTO Scrittura VALUES(60,9788815239334);

INSERT INTO Possesso VALUES('Matematica',9788871927695);
INSERT INTO Possesso VALUES('Economia',9788875433079);
INSERT INTO Possesso VALUES('Diritto',9788859814863);
INSERT INTO Possesso VALUES('Fisica',9788864510316);
INSERT INTO Possesso VALUES('Elettrotecnica',9788808178886);
INSERT INTO Possesso VALUES('Informatica',9788838663772);
INSERT INTO Possesso VALUES('Informatica',9788891908254);
INSERT INTO Possesso VALUES('Informatica',9788808055750);
INSERT INTO Possesso VALUES('Geografia',9788843042463);
INSERT INTO Possesso VALUES('Lettere',9788861847040);
INSERT INTO Possesso VALUES('Fantascienza',9788804668237);
INSERT INTO Possesso VALUES('Rosa',9788838910173);
INSERT INTO Possesso VALUES('Giallo',9788804716372);
INSERT INTO Possesso VALUES('Filosofia',9788800747752);
INSERT INTO Possesso VALUES('Arte',9788807884092);
INSERT INTO Possesso VALUES('Lingue',9788815067180);
INSERT INTO Possesso VALUES('Archeologia',9788842095880);
INSERT INTO Possesso VALUES('Lingue',9788889670132);
INSERT INTO Possesso VALUES('Storia',9788815121264);
INSERT INTO Possesso VALUES('Storia',9788815244123);
INSERT INTO Possesso VALUES('Storia',9788843029886);
INSERT INTO Possesso VALUES('Medicina',9788829928437);
INSERT INTO Possesso VALUES('Medicina',9788815067098);
INSERT INTO Possesso VALUES('Medicina',9788829920860);
INSERT INTO Possesso VALUES('Diritto',9788892103023);
INSERT INTO Possesso VALUES('Medicina',9788804671954);
INSERT INTO Possesso VALUES('Medicina',9788829923175);
INSERT INTO Possesso VALUES('Sociologia',9788842079491);
INSERT INTO Possesso VALUES('Sociologia',9788848200465);
INSERT INTO Possesso VALUES('Sociologia',9788874667543);
INSERT INTO Possesso VALUES('Architettura',9788897356974);
INSERT INTO Possesso VALUES('Architettura',9788845306631);
INSERT INTO Possesso VALUES('Architettura',9788891612861);
INSERT INTO Possesso VALUES('Architettura',9788860084613);
INSERT INTO Possesso VALUES('Diritto',9788834828762);
INSERT INTO Possesso VALUES('Diritto',9788891778604);
INSERT INTO Possesso VALUES('Diritto',9788834879474);
INSERT INTO Possesso VALUES('Diritto',9788892136694);
INSERT INTO Possesso VALUES('Diritto',9788843084784);
INSERT INTO Possesso VALUES('Matematica',9788871926049);
INSERT INTO Possesso VALUES('Medicina',9788879593854);
INSERT INTO Possesso VALUES('Medicina',9788879594837);
INSERT INTO Possesso VALUES('Pedagogia',9788807886515);
INSERT INTO Possesso VALUES('Pedagogia',9788842094777);
INSERT INTO Possesso VALUES('Pedagogia',9788867601592);
INSERT INTO Possesso VALUES('Pedagogia',9788835023289);
INSERT INTO Possesso VALUES('Pedagogia',9788884530738);
INSERT INTO Possesso VALUES('Economia',9788838675508);
INSERT INTO Possesso VALUES('Economia',9788838666377);
INSERT INTO Possesso VALUES('Lingue',9788833923390);
INSERT INTO Possesso VALUES('Medicina',9788891710796);
INSERT INTO Possesso VALUES('Medicina',9788843060368);
INSERT INTO Possesso VALUES('Medicina',9788821429996);
INSERT INTO Possesso VALUES('Economia',9788891414540);
INSERT INTO Possesso VALUES('Economia',9788823834262);
INSERT INTO Possesso VALUES('Economia',9788854859319);
INSERT INTO Possesso VALUES('Ingegneria civile',9788838748455);
INSERT INTO Possesso VALUES('Ingegneria civile',9788838672958);
INSERT INTO Possesso VALUES('Ingegneria civile',9788808059918);
INSERT INTO Possesso VALUES('Ingegneria civile',9788886977128);
INSERT INTO Possesso VALUES('Ingegneria civile',9788820346430);
INSERT INTO Possesso VALUES('Sociologia',9788886412629);
INSERT INTO Possesso VALUES('Lingue',9788815239334);

INSERT INTO Prelevamento VALUES(1,9788875433079,1,119,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788859814863,1,118,'2021-06-23');
INSERT INTO Prelevamento VALUES(1,9788838663772,1,141,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788891908254,1,141,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788861847040,1,149,'2021-06-16');
INSERT INTO Prelevamento VALUES(1,9788838910173,1,104,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788804716372,2,104,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788842095880,2,114,'2021-06-17');
INSERT INTO Prelevamento VALUES(1,9788889670132,2,143,'2021-06-21');
INSERT INTO Prelevamento VALUES(1,9788892103023,3,122,'2021-06-18');
INSERT INTO Prelevamento VALUES(1,9788804671954,3,101,'2021-06-23');
INSERT INTO Prelevamento VALUES(1,9788842079491,3,129,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788848200465,3,129,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788874667543,3,129,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788897356974,3,140,'2021-06-23');
INSERT INTO Prelevamento VALUES(1,9788891612861,3,114,'2021-06-17');
INSERT INTO Prelevamento VALUES(1,9788891778604,4,120,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788871926049,4,107,'2021-06-21');
INSERT INTO Prelevamento VALUES(1,9788879593854,4,147,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788807886515,4,131,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788842094777,4,128,'2021-06-16');
INSERT INTO Prelevamento VALUES(1,9788884530738,4,128,'2021-06-16');
INSERT INTO Prelevamento VALUES(1,9788838675508,5,133,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788838666377,5,133,'2021-06-22');
INSERT INTO Prelevamento VALUES(1,9788843060368,5,103,'2021-06-15');
INSERT INTO Prelevamento VALUES(1,9788891414540,5,119,'2021-06-14');
INSERT INTO Prelevamento VALUES(1,9788854859319,5,135,'2021-06-23');
INSERT INTO Prelevamento VALUES(1,9788838672958,5,108,'2021-06-24');
INSERT INTO Prelevamento VALUES(1,9788886977128,5,108,'2021-06-24');
INSERT INTO Prelevamento VALUES(2,9788875433079,6,135,'2021-06-23');
INSERT INTO Prelevamento VALUES(2,9788864510316,6,107,'2021-06-21');
INSERT INTO Prelevamento VALUES(2,9788891908254,6,139,'2021-06-22');
INSERT INTO Prelevamento VALUES(2,9788808055750,6,139,'2021-06-22');
INSERT INTO Prelevamento VALUES(2,9788804716372,7,109,'2021-06-21');
INSERT INTO Prelevamento VALUES(2,9788842095880,7,117,'2021-06-21');
INSERT INTO Prelevamento VALUES(2,9788843029886,7,136,'2021-06-15');
INSERT INTO Prelevamento VALUES(2,9788892103023,8,120,'2021-06-22');
INSERT INTO Prelevamento VALUES(2,9788804671954,8,150,'2021-06-22');
INSERT INTO Prelevamento VALUES(2,9788848200465,8,102,'2021-06-15');
INSERT INTO Prelevamento VALUES(2,9788834828762,9,142,'2021-06-23');
INSERT INTO Prelevamento VALUES(2,9788842094777,9,129,'2021-06-14');
INSERT INTO Prelevamento VALUES(2,9788867601592,9,131,'2021-06-22');
INSERT INTO Prelevamento VALUES(2,9788838666377,10,134,'2021-06-24');
INSERT INTO Prelevamento VALUES(2,9788891710796,10,101,'2021-06-23');
INSERT INTO Prelevamento VALUES(2,9788821429996,10,126,'2021-06-22');
INSERT INTO Prelevamento VALUES(2,9788838748455,10,108,'2021-06-24');
INSERT INTO Prelevamento VALUES(2,9788838672958,10,137,'2021-06-24');
INSERT INTO Prelevamento VALUES(2,9788815239334,7,143,'2021-06-21');
INSERT INTO Prelevamento VALUES(3,9788871927695,11,106,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788875433079,11,134,'2021-06-24');
INSERT INTO Prelevamento VALUES(3,9788838663772,11,106,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788843042463,11,121,'2021-06-14');
INSERT INTO Prelevamento VALUES(3,9788838910173,11,138,'2021-06-14');
INSERT INTO Prelevamento VALUES(3,9788804716372,12,149,'2021-06-16');
INSERT INTO Prelevamento VALUES(3,9788807884092,12,131,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788842095880,12,127,'2021-06-23');
INSERT INTO Prelevamento VALUES(3,9788815244123,12,136,'2021-06-15');
INSERT INTO Prelevamento VALUES(3,9788843029886,12,138,'2021-06-14');
INSERT INTO Prelevamento VALUES(3,9788815067098,13,105,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788829920860,13,125,'2021-06-21');
INSERT INTO Prelevamento VALUES(3,9788892103023,13,118,'2021-06-23');
INSERT INTO Prelevamento VALUES(3,9788842079491,13,112,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788848200465,13,112,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788897356974,13,127,'2021-06-23');
INSERT INTO Prelevamento VALUES(3,9788845306631,13,117,'2021-06-21');
INSERT INTO Prelevamento VALUES(3,9788891778604,14,127,'2021-06-23');
INSERT INTO Prelevamento VALUES(3,9788834879474,14,118,'2021-06-23');
INSERT INTO Prelevamento VALUES(3,9788843084784,14,123,'2021-06-16');
INSERT INTO Prelevamento VALUES(3,9788879593854,14,130,'2021-06-24');
INSERT INTO Prelevamento VALUES(3,9788807886515,14,128,'2021-06-16');
INSERT INTO Prelevamento VALUES(3,9788842094777,14,102,'2021-06-15');
INSERT INTO Prelevamento VALUES(3,9788867601592,14,102,'2021-06-15');
INSERT INTO Prelevamento VALUES(3,9788884530738,14,102,'2021-06-15');
INSERT INTO Prelevamento VALUES(3,9788838666377,15,135,'2021-06-23');
INSERT INTO Prelevamento VALUES(3,9788891710796,15,105,'2021-06-22');
INSERT INTO Prelevamento VALUES(3,9788821429996,15,125,'2021-06-21');
INSERT INTO Prelevamento VALUES(3,9788854859319,15,134,'2021-06-24');
INSERT INTO Prelevamento VALUES(3,9788838748455,15,137,'2021-06-24');
INSERT INTO Prelevamento VALUES(3,9788808059918,15,108,'2021-06-24');

INSERT INTO Restituzione VALUES(1,9788871927695,1,111,'2021-05-14');
INSERT INTO Restituzione VALUES(1,9788864510316,1,107,'2021-04-15');
INSERT INTO Restituzione VALUES(1,9788808178886,1,106,'2021-05-05');
INSERT INTO Restituzione VALUES(1,9788808055750,1,106,'2021-04-27');
INSERT INTO Restituzione VALUES(1,9788843042463,1,121,'2021-03-12');
INSERT INTO Restituzione VALUES(1,9788804668237,1,104,'2021-06-01');
INSERT INTO Restituzione VALUES(1,9788800747752,2,149,'2021-04-06');
INSERT INTO Restituzione VALUES(1,9788807884092,2,136,'2021-03-02');
INSERT INTO Restituzione VALUES(1,9788815067180,2,143,'2021-05-11');
INSERT INTO Restituzione VALUES(1,9788815121264,2,136,'2021-04-22');
INSERT INTO Restituzione VALUES(1,9788815244123,2,136,'2021-05-18');
INSERT INTO Restituzione VALUES(1,9788843029886,2,138,'2021-03-24');
INSERT INTO Restituzione VALUES(1,9788829928437,3,130,'2021-02-16');
INSERT INTO Restituzione VALUES(1,9788815067098,3,150,'2021-05-27');
INSERT INTO Restituzione VALUES(1,9788829920860,3,124,'2021-05-04');
INSERT INTO Restituzione VALUES(1,9788829923175,3,126,'2021-04-12');
INSERT INTO Restituzione VALUES(1,9788845306631,3,114,'2021-03-25');
INSERT INTO Restituzione VALUES(1,9788860084613,3,117,'2021-05-10');
INSERT INTO Restituzione VALUES(1,9788834828762,4,122,'2021-03-16');
INSERT INTO Restituzione VALUES(1,9788834879474,4,123,'2021-05-19');
INSERT INTO Restituzione VALUES(1,9788892136694,4,123,'2021-05-07');
INSERT INTO Restituzione VALUES(1,9788843084784,4,118,'2021-04-15');
INSERT INTO Restituzione VALUES(1,9788879594837,4,126,'2021-03-29');
INSERT INTO Restituzione VALUES(1,9788867601592,4,131,'2021-04-28');
INSERT INTO Restituzione VALUES(1,9788835023289,4,131,'2021-05-21');
INSERT INTO Restituzione VALUES(1,9788833923390,5,113,'2021-06-04');
INSERT INTO Restituzione VALUES(1,9788891710796,5,105,'2021-04-14');
INSERT INTO Restituzione VALUES(1,9788821429996,5,125,'2021-01-29');
INSERT INTO Restituzione VALUES(1,9788823834262,5,134,'2021-03-10');
INSERT INTO Restituzione VALUES(1,9788838748455,5,137,'2021-06-08');
INSERT INTO Restituzione VALUES(1,9788808059918,5,137,'2021-05-12');
INSERT INTO Restituzione VALUES(1,9788820346430,1,137,'2021-05-10');
INSERT INTO Restituzione VALUES(1,9788886412629,1,131,'2021-03-05');
INSERT INTO Restituzione VALUES(1,9788815239334,2,144,'2021-06-11');
INSERT INTO Restituzione VALUES(2,9788871927695,6,111,'2021-02-19');
INSERT INTO Restituzione VALUES(2,9788859814863,6,122,'2021-01-28');
INSERT INTO Restituzione VALUES(2,9788808178886,6,110,'2021-01-27');
INSERT INTO Restituzione VALUES(2,9788838663772,6,108,'2021-04-28');
INSERT INTO Restituzione VALUES(2,9788843042463,6,112,'2021-05-19');
INSERT INTO Restituzione VALUES(2,9788861847040,6,149,'2021-06-03');
INSERT INTO Restituzione VALUES(2,9788804668237,6,128,'2021-04-23');
INSERT INTO Restituzione VALUES(2,9788838910173,6,149,'2021-02-25');
INSERT INTO Restituzione VALUES(2,9788800747752,7,104,'2021-02-15');
INSERT INTO Restituzione VALUES(2,9788807884092,7,129,'2021-06-03');
INSERT INTO Restituzione VALUES(2,9788815067180,7,146,'2021-05-18');
INSERT INTO Restituzione VALUES(2,9788889670132,7,145,'2021-06-11');
INSERT INTO Restituzione VALUES(2,9788815121264,7,136,'2021-03-24');
INSERT INTO Restituzione VALUES(2,9788815244123,7,136,'2021-03-24');
INSERT INTO Restituzione VALUES(2,9788829928437,8,115,'2021-02-25');
INSERT INTO Restituzione VALUES(2,9788815067098,8,101,'2021-05-27');
INSERT INTO Restituzione VALUES(2,9788829920860,8,124,'2021-01-26');
INSERT INTO Restituzione VALUES(2,9788829923175,8,148,'2021-04-07');
INSERT INTO Restituzione VALUES(2,9788842079491,8,131,'2021-01-29');
INSERT INTO Restituzione VALUES(2,9788874667543,8,131,'2021-01-29');
INSERT INTO Restituzione VALUES(2,9788897356974,8,117,'2021-02-12');
INSERT INTO Restituzione VALUES(2,9788845306631,8,127,'2021-02-16');
INSERT INTO Restituzione VALUES(2,9788891612861,8,114,'2021-04-20');
INSERT INTO Restituzione VALUES(2,9788860084613,8,114,'2021-05-21');
INSERT INTO Restituzione VALUES(2,9788891778604,9,132,'2021-03-10');
INSERT INTO Restituzione VALUES(2,9788834879474,9,132,'2021-03-10');
INSERT INTO Restituzione VALUES(2,9788892136694,9,122,'2021-04-28');
INSERT INTO Restituzione VALUES(2,9788843084784,9,120,'2021-05-13');
INSERT INTO Restituzione VALUES(2,9788871926049,9,111,'2021-05-19');
INSERT INTO Restituzione VALUES(2,9788879593854,9,124,'2021-05-27');
INSERT INTO Restituzione VALUES(2,9788879594837,9,115,'2021-06-04');
INSERT INTO Restituzione VALUES(2,9788807886515,9,116,'2021-03-25');
INSERT INTO Restituzione VALUES(2,9788835023289,9,131,'2021-03-11');
INSERT INTO Restituzione VALUES(2,9788884530738,9,112,'2021-01-27');
INSERT INTO Restituzione VALUES(2,9788838675508,10,135,'2021-02-24');
INSERT INTO Restituzione VALUES(2,9788833923390,10,146,'2021-02-09');
INSERT INTO Restituzione VALUES(2,9788843060368,10,105,'2021-04-16');
INSERT INTO Restituzione VALUES(2,9788891414540,10,135,'2021-04-14');
INSERT INTO Restituzione VALUES(2,9788823834262,10,133,'2021-03-22');
INSERT INTO Restituzione VALUES(2,9788854859319,10,137,'2021-06-04');
INSERT INTO Restituzione VALUES(2,9788808059918,10,108,'2021-06-09');
INSERT INTO Restituzione VALUES(2,9788886977128,10,108,'2021-06-09');
INSERT INTO Restituzione VALUES(2,9788820346430,6,137,'2021-04-14');
INSERT INTO Restituzione VALUES(2,9788886412629,6,144,'2021-05-20');
INSERT INTO Restituzione VALUES(3,9788859814863,11,149,'2021-01-29');
INSERT INTO Restituzione VALUES(3,9788864510316,11,110,'2021-06-01');
INSERT INTO Restituzione VALUES(3,9788808178886,11,141,'2021-04-07');
INSERT INTO Restituzione VALUES(3,9788891908254,11,141,'2021-01-15');
INSERT INTO Restituzione VALUES(3,9788808055750,11,141,'2021-06-09');
INSERT INTO Restituzione VALUES(3,9788861847040,11,104,'2021-05-12');
INSERT INTO Restituzione VALUES(3,9788804668237,11,103,'2021-02-10');
INSERT INTO Restituzione VALUES(3,9788800747752,12,149,'2021-03-24');
INSERT INTO Restituzione VALUES(3,9788815067180,12,146,'2021-02-02');
INSERT INTO Restituzione VALUES(3,9788889670132,12,143,'2021-01-25');
INSERT INTO Restituzione VALUES(3,9788815121264,12,148,'2021-01-29');
INSERT INTO Restituzione VALUES(3,9788829928437,13,125,'2021-04-27');
INSERT INTO Restituzione VALUES(3,9788804671954,13,103,'2021-04-21');
INSERT INTO Restituzione VALUES(3,9788829923175,13,105,'2021-05-04');
INSERT INTO Restituzione VALUES(3,9788874667543,13,102,'2021-03-12');
INSERT INTO Restituzione VALUES(3,9788891612861,13,121,'2021-06-01');
INSERT INTO Restituzione VALUES(3,9788860084613,13,114,'2021-05-27');
INSERT INTO Restituzione VALUES(3,9788834828762,14,123,'2021-01-22');
INSERT INTO Restituzione VALUES(3,9788892136694,14,123,'2021-02-19');
INSERT INTO Restituzione VALUES(3,9788871926049,14,107,'2021-02-25');
INSERT INTO Restituzione VALUES(3,9788879594837,14,125,'2021-03-15');
INSERT INTO Restituzione VALUES(3,9788835023289,14,112,'2021-06-04');
INSERT INTO Restituzione VALUES(3,9788838675508,15,135,'2021-06-09');
INSERT INTO Restituzione VALUES(3,9788833923390,15,144,'2021-04-20');
INSERT INTO Restituzione VALUES(3,9788843060368,15,103,'2021-01-27');
INSERT INTO Restituzione VALUES(3,9788891414540,15,134,'2021-02-10');
INSERT INTO Restituzione VALUES(3,9788823834262,15,134,'2021-03-29');
INSERT INTO Restituzione VALUES(3,9788838672958,15,137,'2021-04-19');
INSERT INTO Restituzione VALUES(3,9788886977128,15,108,'2021-05-07');
INSERT INTO Restituzione VALUES(3,9788820346430,11,137,'2021-02-05');
INSERT INTO Restituzione VALUES(3,9788886412629,11,128,'2021-01-22');
INSERT INTO Restituzione VALUES(3,9788815239334,12,144,'2021-02-25');

INSERT INTO Composizione VALUES(201,105,'2021-04-07');
INSERT INTO Composizione VALUES(202,107,'2021-02-18');
INSERT INTO Composizione VALUES(203,109,'2021-01-27');
INSERT INTO Composizione VALUES(204,113,'2021-05-28');
INSERT INTO Composizione VALUES(205,120,'2021-05-06');
INSERT INTO Composizione VALUES(206,126,'2021-03-22');
INSERT INTO Composizione VALUES(207,134,'2021-02-03');
INSERT INTO Composizione VALUES(208,139,'2021-06-22');
INSERT INTO Composizione VALUES(209,142,'2021-06-23');
INSERT INTO Composizione VALUES(210,147,'2021-06-22');