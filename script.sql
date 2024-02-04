<<<<<<< HEAD
DROP TABLE IF EXISTS ADVENTURER_CLASS, PLAYER, ITEM, INVENTORY, CHEST, SHOP, SALE, ENEMY, ENEMYDROP, PLAYER_SESSION, MAP_LOCATION, RARITY CASCADE;

CREATE TABLE PLAYER (
    IDPLAYER SERIAL NOT NULL,
    IDCLASS SMALLINT NOT NULL,
    PSEUDO VARCHAR(50) NOT NULL DEFAULT 'ANONYMOUS',
    HEALTH NUMERIC(5,2) NOT NULL DEFAULT 100,
    ATTACK SMALLINT NOT NULL DEFAULT 0,
    LUCK SMALLINT NOT NULL DEFAULT 0,
    DEFENSE SMALLINT NOT NULL DEFAULT 0,
    PURSE INT NOT NULL DEFAULT 0,
    IDWEAPON SMALLINT NULL,
    IDARMOR SMALLINT NULL,

    CONSTRAINT PK_PLAYER PRIMARY KEY (IDPLAYER),
    CONSTRAINT CK_HEALTH CHECK (HEALTH BETWEEN 0 AND 100),
    CONSTRAINT CK_ATTACK CHECK (ATTACK >= 0),
    CONSTRAINT CK_LUCK CHECK (LUCK BETWEEN -25 AND 250),
    CONSTRAINT CK_DEFENSE CHECK (DEFENSE BETWEEN -25 AND 250)
);

CREATE TABLE PLAYER_SESSION (
	IDPLAYER SERIAL NOT NULL,
	IDSESSION SMALLINT NOT NULL,
	IDLOCATION SMALLINT NOT NULL,
	LASTCONNECTION DATE NULL DEFAULT NOW(),
	
	CONSTRAINT PK_IDSESSION PRIMARY KEY (IDSESSION)
);

CREATE TABLE MAP_LOCATION (
	IDLOCATION SMALLINT NOT NULL,
	DESCRIPTIONLOCATION VARCHAR(50) NOT NULL,
	
	CONSTRAINT PK_IDLOCATION PRIMARY KEY (IDLOCATION)
);

CREATE TABLE ADVENTURER_CLASS (
    IDCLASS SERIAL NOT NULL,
    CLASSNAME VARCHAR(30) NOT NULL,
    BASE_ATK SMALLINT NOT NULL DEFAULT 0,
    BASE_HP NUMERIC(5,2) NOT NULL DEFAULT 100,
    BASE_LUCK SMALLINT NOT NULL DEFAULT 0,
    BASE_DEF SMALLINT NOT NULL DEFAULT 0,
    BASE_PURSE SMALLINT NOT NULL DEFAULT 0,

    CONSTRAINT PK_IDCLASS PRIMARY KEY (IDCLASS)
);

CREATE TABLE RARITY(
	IDRARITY SMALLINT NOT NULL,
	NAMERARITY VARCHAR(30) NOT NULL,
	
	CONSTRAINT PK_RARITY PRIMARY KEY (IDRARITY)
);

CREATE TABLE ITEM (
    IDITEM SMALLINT NOT NULL,
    ITEMNAME VARCHAR(50) NOT NULL,
    BONUS_ATK SMALLINT NULL DEFAULT 0,
    BONUS_DEF SMALLINT NULL DEFAULT 0,
    BONUS_LUCK SMALLINT NULL DEFAULT 0,
    HP_HEALING SMALLINT NULL DEFAULT 0,
    ITEMVALUE SMALLINT NOT NULL DEFAULT 0,
	IDRARITY SMALLINT NOT NULL DEFAULT '1',
	
    CONSTRAINT PK_IDITEM PRIMARY KEY (IDITEM),
	CONSTRAINT CK_PRICE CHECK (ITEMVALUE >= 0)
);

CREATE TABLE INVENTORY (
    IDPLAYER INT NOT NULL,
    IDITEM SMALLINT NOT NULL,
    QUANTITY SMALLINT NOT NULL DEFAULT 1,
	DATEOBTAINING DATE NOT NULL DEFAULT NOW(),

    CONSTRAINT CK_QUANTITY CHECK (QUANTITY >= 1)
);

CREATE TABLE CHEST (
    IDCHEST SMALLINT NOT NULL,
    IDITEM SMALLINT NOT NULL,

    CONSTRAINT PK_IDCHEST PRIMARY KEY (IDCHEST)
);

CREATE TABLE SHOP (
    IDSHOP SERIAL NOT NULL,
    SHOPNAME VARCHAR(50) NOT NULL,
    MESSAGEINTRODUCTION VARCHAR(200) NULL,
    MESSAGECONCLUSION VARCHAR(200) NULL,

    CONSTRAINT PK_IDSHOP PRIMARY KEY (IDSHOP)
);

CREATE TABLE SALE (
    IDSHOP SMALLINT NOT NULL,
    STOCK SMALLINT NOT NULL DEFAULT 1,
    IDITEM SMALLINT NOT NULL,
    QUANTITY SMALLINT NOT NULL DEFAULT 1,

    CONSTRAINT CK_QUANTITY CHECK (QUANTITY >= 1)
);

CREATE TABLE ENEMY(
	IDENEMY SERIAL NOT NULL,
	DAMAGE SMALLINT NOT NULL,
	HEALTH SMALLINT NOT NULL,
	DESCRIPTION VARCHAR(150) NOT NULL,
	INTRODUCTION VARCHAR(250) NULL DEFAULT 'Un ennemi s''approche.',
	CONCLUSION VARCHAR(250) NULL DEFAULT 'L''ennemi a été vaincu.',
	
	CONSTRAINT PK_IDENEMY PRIMARY KEY (IDENEMY),
	CONSTRAINT CK_DAMAGE CHECK (DAMAGE >= 0),
	CONSTRAINT CK_HEALTH CHECK (HEALTH >= 0)
);

CREATE TABLE ENEMYDROP(
	IDENEMY SMALLINT NOT NULL,
	IDITEM SMALLINT NOT NULL,
	QUANTITY SMALLINT NOT NULL DEFAULT 1
);

ALTER TABLE PLAYER_SESSION
ADD CONSTRAINT FK_PLAYERSESSION FOREIGN KEY (IDPLAYER) 
REFERENCES PLAYER (IDPLAYER);

ALTER TABLE PLAYER_SESSION
ADD CONSTRAINT FK_PLAYERLOCATION FOREIGN KEY (IDLOCATION) 
REFERENCES MAP_LOCATION (IDLOCATION);
	
ALTER TABLE ENEMYDROP
ADD CONSTRAINT FK_ITEMDROP FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE SALE
ADD CONSTRAINT FK_SALEITEM FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE SALE
ADD CONSTRAINT FK_IDSHOP FOREIGN KEY (IDSHOP)
REFERENCES SHOP (IDSHOP);

ALTER TABLE CHEST
ADD CONSTRAINT FK_CHESTITEM FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE PLAYER
ADD CONSTRAINT FK_PLAYERCLASS FOREIGN KEY (IDCLASS)
REFERENCES ADVENTURER_CLASS (IDCLASS);

ALTER TABLE PLAYER
ADD CONSTRAINT FK_PLAYERARMOR FOREIGN KEY (IDARMOR)
REFERENCES ITEM (IDITEM);

ALTER TABLE PLAYER
ADD CONSTRAINT FK_PLAYERWEAPON FOREIGN KEY (IDWEAPON)
REFERENCES ITEM (IDITEM);

ALTER TABLE INVENTORY
ADD CONSTRAINT FK_INVENTORYITEM FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE INVENTORY
ADD CONSTRAINT FK_INVENTORYPLAYER FOREIGN KEY (IDPLAYER)
REFERENCES PLAYER (IDPLAYER);

ALTER TABLE ITEM
ADD CONSTRAINT FK_RARITYITEM FOREIGN KEY (IDRARITY)
REFERENCES RARITY (IDRARITY);

CREATE INDEX idx_idplayer ON PLAYER (IDPLAYER);
CREATE INDEX idx_iditem ON ITEM (IDITEM);
CREATE INDEX idx_idenemy on ENEMY (IDENEMY);

INSERT INTO RARITY (IDRARITY, NAMERARITY)
VALUES
(1, 'COMMUN'),
(2, 'PEU COMMUN'),
(3, 'ÉPIQUE'),
(4, 'LÉGENDAIRE'),
(5, 'MYTHIQUE'),
(6, 'RARE'),
(7, 'TRÈS RARE'),
(8, 'EXCEPTIONNEL'),
(9, 'INÉGALÉ'),
(10, 'DIVIN');

INSERT INTO ITEM (IDITEM, ITEMNAME, BONUS_ATK, BONUS_DEF, BONUS_LUCK, HP_HEALING, ITEMVALUE, IDRARITY)
VALUES
(1, 'Épée du Pouvoir', 10, 5, 0, 0, 50, 3),
(2, 'Bouclier de Protection', 0, 15, 0, 0, 40, 2),
(3, 'Potion de Guérison', 0, 0, 0, 20, 15, 1),
(4, 'Bâton de Sagesse', 8, 3, 5, 0, 60, 4),
(5, 'Arc des Ombres', 15, 2, 0, 0, 55, 5),
(6, 'Armure du Chevalier', 0, 20, 0, 0, 70, 4),
(7, 'Bague de Chance', 0, 0, 10, 0, 30, 7),
(8, 'Livre Ancien des Sortilèges', 12, 8, 5, 0, 80, 6),
(9, 'Amulette de Protection', 0, 10, 0, 0, 45, 8),
(10, 'Grimoire des Illusions', 5, 5, 15, 0, 65, 9),
(11, 'Dague de l''Ombre', 18, 1, 0, 0, 50, 7),
(12, 'Potion de Force', 0, 0, 0, 25, 20, 3),
(13, 'Couronne Royale', 0, 25, 10, 0, 90, 5),
(14, 'Élixir d''Immortalité', 0, 0, 0, 50, 100, 10),
(15, 'Marteau du Tonnerre', 25, 5, 0, 0, 75, 6),
(16, 'Bottes de Vitesse', 0, 3, 8, 0, 40, 8),
(17, 'Collier de Vie', 0, 15, 0, 5, 60, 9),
(18, 'Hache du Barbare', 30, 10, 0, 0, 85, 7),
(19, 'Anneau des Éléments', 12, 12, 12, 12, 120, 10),
(20, 'Lance du Dragon', 20, 15, 0, 0, 95, 6);

INSERT INTO ENEMY (IDENEMY, DAMAGE, HEALTH, DESCRIPTION, INTRODUCTION, CONCLUSION)
VALUES
(1, 10, 50, 'Goblin', 'Un gobelin s''approche.', 'Le gobelin a été vaincu.'),
(2, 15, 70, 'Squelette', 'Un squelette apparaît.', 'Le squelette a été détruit.'),
(3, 20, 80, 'Orc', 'Un orc féroce vous attaque.', 'L''orc gît au sol, vaincu.'),
(4, 25, 100, 'Loup des Ténèbres', 'Un loup noir surgit des ombres.', 'Le loup des ténèbres est vaincu.'),
(5, 30, 120, 'Sorcier Malfaisant', 'Un sorcier sombre lance des malédictions.', 'Le sorcier malfaisant est vaincu.'),
(6, 18, 90, 'Harpie', 'Une harpie fond sur vous avec ses serres aiguisées.', 'La harpie est vaincue.'),
(7, 22, 110, 'Golem de Pierre', 'Un imposant golem de pierre se dresse devant vous.', 'Le golem de pierre est détruit.'),
(8, 28, 150, 'Banshee', 'La banshee pleure une mélodie sinistre.', 'La banshee a été apaisée.'),
(9, 32, 130, 'Minotaure', 'Un minotaure puissant charge avec sa hache massive.', 'Le minotaure succombe à la bataille.'),
(10, 35, 180, 'Dragon des Ombres', 'Les yeux brillants du dragon des ombres vous fixent.', 'Le dragon des ombres est terrassé.'),
(11, 15, 60, 'Chauve-souris Vampire', 'Une chauve-souris vampire fond sur vous.', 'La chauve-souris vampire est éliminée.'),
(12, 20, 75, 'Liche Malefique', 'Une liche invoque des forces obscures.', 'La liche est vaincue.'),
(13, 27, 95, 'Serpent Venimeux', 'Un serpent venimeux siffle et attaque.', 'Le serpent venimeux a été éliminé.'),
(14, 30, 110, 'Spectre Glacial', 'Un spectre glacial émane une aura de froid.', 'Le spectre glacial est dissipé.'),
(15, 40, 140, 'Hydre Infernale', 'Une hydre à plusieurs têtes crache des flammes.', 'L''hydre infernale est vaincue.'),
(16, 18, 80, 'Gargouille Pétrifiante', 'Une gargouille pétrifiante se réveille.', 'La gargouille pétrifiante est réduite en morceaux.'),
(17, 24, 120, 'Démon des Abysses', 'Un démon surgit des abysses pour vous défier.', 'Le démon des abysses est banni.'),
(18, 28, 160, 'Phoenix Sombre', 'Un phoenix sombre engloutit tout de ses flammes noires.', 'Le phoenix sombre est anéanti.'),
(19, 22, 100, 'Chimère Féroce', 'Une chimère féroce rugit et attaque.', 'La chimère féroce est terrassée.'),
(20, 38, 200, 'Titan Colossal', 'Un titan colossal ébranle le sol de ses pas.', 'Le titan colossal est vaincu.');

INSERT INTO ENEMYDROP (IDENEMY, IDITEM, QUANTITY)
VALUES
(1, 1, 1),
(2, 3, 2),
(3, 5, 1),
(4, 7, 1),
(5, 10, 1),
(6, 12, 1),
(7, 15, 2),
(8, 18, 1),
(9, 20, 1),
(11, 2, 1),
(12, 8, 1),
(13, 11, 1),
(14, 14, 1),
=======
DROP TABLE IF EXISTS ADVENTURER_CLASS, PLAYER, ITEM, INVENTORY, CHEST, SHOP, SALE, ENEMY, ENEMYDROP, PLAYER_SESSION, MAP_LOCATION, RARITY CASCADE;

CREATE TABLE PLAYER (
    IDPLAYER SERIAL NOT NULL,
    IDCLASS SMALLINT NOT NULL,
    PSEUDO VARCHAR(50) NOT NULL DEFAULT 'ANONYMOUS',
    HEALTH NUMERIC(5,2) NOT NULL DEFAULT 100,
    ATTACK SMALLINT NOT NULL DEFAULT 0,
    LUCK SMALLINT NOT NULL DEFAULT 0,
    DEFENSE SMALLINT NOT NULL DEFAULT 0,
    PURSE INT NOT NULL DEFAULT 0,
    IDWEAPON SMALLINT NULL,
    IDARMOR SMALLINT NULL,

    CONSTRAINT PK_PLAYER PRIMARY KEY (IDPLAYER),
    CONSTRAINT CK_HEALTH CHECK (HEALTH BETWEEN 0 AND 100),
    CONSTRAINT CK_ATTACK CHECK (ATTACK >= 0),
    CONSTRAINT CK_LUCK CHECK (LUCK BETWEEN -25 AND 250),
    CONSTRAINT CK_DEFENSE CHECK (DEFENSE BETWEEN -25 AND 250)
);

CREATE TABLE PLAYER_SESSION (
	IDPLAYER SERIAL NOT NULL,
	IDSESSION SMALLINT NOT NULL,
	IDLOCATION SMALLINT NOT NULL,
	LASTCONNECTION DATE NULL DEFAULT NOW(),
	
	CONSTRAINT PK_IDSESSION PRIMARY KEY (IDSESSION)
);

CREATE TABLE MAP_LOCATION (
	IDLOCATION SMALLINT NOT NULL,
	DESCRIPTIONLOCATION VARCHAR(50) NOT NULL,
	
	CONSTRAINT PK_IDLOCATION PRIMARY KEY (IDLOCATION)
);

CREATE TABLE ADVENTURER_CLASS (
    IDCLASS SERIAL NOT NULL,
    CLASSNAME VARCHAR(30) NOT NULL,
    BASE_ATK SMALLINT NOT NULL DEFAULT 0,
    BASE_HP NUMERIC(5,2) NOT NULL DEFAULT 100,
    BASE_LUCK SMALLINT NOT NULL DEFAULT 0,
    BASE_DEF SMALLINT NOT NULL DEFAULT 0,
    BASE_PURSE SMALLINT NOT NULL DEFAULT 0,

    CONSTRAINT PK_IDCLASS PRIMARY KEY (IDCLASS)
);

CREATE TABLE RARITY(
	IDRARITY SMALLINT NOT NULL,
	NAMERARITY VARCHAR(30) NOT NULL,
	
	CONSTRAINT PK_RARITY PRIMARY KEY (IDRARITY)
);

CREATE TABLE ITEM (
    IDITEM SMALLINT NOT NULL,
    ITEMNAME VARCHAR(50) NOT NULL,
    BONUS_ATK SMALLINT NULL DEFAULT 0,
    BONUS_DEF SMALLINT NULL DEFAULT 0,
    BONUS_LUCK SMALLINT NULL DEFAULT 0,
    HP_HEALING SMALLINT NULL DEFAULT 0,
    ITEMVALUE SMALLINT NOT NULL DEFAULT 0,
	IDRARITY SMALLINT NOT NULL DEFAULT '1',
	
    CONSTRAINT PK_IDITEM PRIMARY KEY (IDITEM),
	CONSTRAINT CK_PRICE CHECK (ITEMVALUE >= 0)
);

CREATE TABLE INVENTORY (
    IDPLAYER INT NOT NULL,
    IDITEM SMALLINT NOT NULL,
    QUANTITY SMALLINT NOT NULL DEFAULT 1,
	DATEOBTAINING DATE NOT NULL DEFAULT NOW(),

    CONSTRAINT CK_QUANTITY CHECK (QUANTITY >= 1)
);

CREATE TABLE CHEST (
    IDCHEST SMALLINT NOT NULL,
    IDITEM SMALLINT NOT NULL,

    CONSTRAINT PK_IDCHEST PRIMARY KEY (IDCHEST)
);

CREATE TABLE SHOP (
    IDSHOP SERIAL NOT NULL,
    SHOPNAME VARCHAR(50) NOT NULL,
    MESSAGEINTRODUCTION VARCHAR(200) NULL,
    MESSAGECONCLUSION VARCHAR(200) NULL,

    CONSTRAINT PK_IDSHOP PRIMARY KEY (IDSHOP)
);

CREATE TABLE SALE (
    IDSHOP SMALLINT NOT NULL,
    STOCK SMALLINT NOT NULL DEFAULT 1,
    IDITEM SMALLINT NOT NULL,
    QUANTITY SMALLINT NOT NULL DEFAULT 1,

    CONSTRAINT CK_QUANTITY CHECK (QUANTITY >= 1)
);

CREATE TABLE ENEMY(
	IDENEMY SERIAL NOT NULL,
	DAMAGE SMALLINT NOT NULL,
	HEALTH SMALLINT NOT NULL,
	DESCRIPTION VARCHAR(150) NOT NULL,
	INTRODUCTION VARCHAR(250) NULL DEFAULT 'Un ennemi s''approche.',
	CONCLUSION VARCHAR(250) NULL DEFAULT 'L''ennemi a été vaincu.',
	
	CONSTRAINT PK_IDENEMY PRIMARY KEY (IDENEMY),
	CONSTRAINT CK_DAMAGE CHECK (DAMAGE >= 0),
	CONSTRAINT CK_HEALTH CHECK (HEALTH >= 0)
);

CREATE TABLE ENEMYDROP(
	IDENEMY SMALLINT NOT NULL,
	IDITEM SMALLINT NOT NULL,
	QUANTITY SMALLINT NOT NULL DEFAULT 1
);

ALTER TABLE PLAYER_SESSION
ADD CONSTRAINT FK_PLAYERSESSION FOREIGN KEY (IDPLAYER) 
REFERENCES PLAYER (IDPLAYER);

ALTER TABLE PLAYER_SESSION
ADD CONSTRAINT FK_PLAYERLOCATION FOREIGN KEY (IDLOCATION) 
REFERENCES MAP_LOCATION (IDLOCATION);
	
ALTER TABLE ENEMYDROP
ADD CONSTRAINT FK_ITEMDROP FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE SALE
ADD CONSTRAINT FK_SALEITEM FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE SALE
ADD CONSTRAINT FK_IDSHOP FOREIGN KEY (IDSHOP)
REFERENCES SHOP (IDSHOP);

ALTER TABLE CHEST
ADD CONSTRAINT FK_CHESTITEM FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE PLAYER
ADD CONSTRAINT FK_PLAYERCLASS FOREIGN KEY (IDCLASS)
REFERENCES ADVENTURER_CLASS (IDCLASS);

ALTER TABLE PLAYER
ADD CONSTRAINT FK_PLAYERARMOR FOREIGN KEY (IDARMOR)
REFERENCES ITEM (IDITEM);

ALTER TABLE PLAYER
ADD CONSTRAINT FK_PLAYERWEAPON FOREIGN KEY (IDWEAPON)
REFERENCES ITEM (IDITEM);

ALTER TABLE INVENTORY
ADD CONSTRAINT FK_INVENTORYITEM FOREIGN KEY (IDITEM)
REFERENCES ITEM (IDITEM);

ALTER TABLE INVENTORY
ADD CONSTRAINT FK_INVENTORYPLAYER FOREIGN KEY (IDPLAYER)
REFERENCES PLAYER (IDPLAYER);

ALTER TABLE ITEM
ADD CONSTRAINT FK_RARITYITEM FOREIGN KEY (IDRARITY)
REFERENCES RARITY (IDRARITY);

CREATE INDEX idx_idplayer ON PLAYER (IDPLAYER);
CREATE INDEX idx_iditem ON ITEM (IDITEM);
CREATE INDEX idx_idenemy on ENEMY (IDENEMY);

INSERT INTO RARITY (IDRARITY, NAMERARITY)
VALUES
(1, 'COMMUN'),
(2, 'PEU COMMUN'),
(3, 'ÉPIQUE'),
(4, 'LÉGENDAIRE'),
(5, 'MYTHIQUE'),
(6, 'RARE'),
(7, 'TRÈS RARE'),
(8, 'EXCEPTIONNEL'),
(9, 'INÉGALÉ'),
(10, 'DIVIN');

INSERT INTO ITEM (IDITEM, ITEMNAME, BONUS_ATK, BONUS_DEF, BONUS_LUCK, HP_HEALING, ITEMVALUE, IDRARITY)
VALUES
(1, 'Épée du Pouvoir', 10, 5, 0, 0, 50, 3),
(2, 'Bouclier de Protection', 0, 15, 0, 0, 40, 2),
(3, 'Potion de Guérison', 0, 0, 0, 20, 15, 1),
(4, 'Bâton de Sagesse', 8, 3, 5, 0, 60, 4),
(5, 'Arc des Ombres', 15, 2, 0, 0, 55, 5),
(6, 'Armure du Chevalier', 0, 20, 0, 0, 70, 4),
(7, 'Bague de Chance', 0, 0, 10, 0, 30, 7),
(8, 'Livre Ancien des Sortilèges', 12, 8, 5, 0, 80, 6),
(9, 'Amulette de Protection', 0, 10, 0, 0, 45, 8),
(10, 'Grimoire des Illusions', 5, 5, 15, 0, 65, 9),
(11, 'Dague de l''Ombre', 18, 1, 0, 0, 50, 7),
(12, 'Potion de Force', 0, 0, 0, 25, 20, 3),
(13, 'Couronne Royale', 0, 25, 10, 0, 90, 5),
(14, 'Élixir d''Immortalité', 0, 0, 0, 50, 100, 10),
(15, 'Marteau du Tonnerre', 25, 5, 0, 0, 75, 6),
(16, 'Bottes de Vitesse', 0, 3, 8, 0, 40, 8),
(17, 'Collier de Vie', 0, 15, 0, 5, 60, 9),
(18, 'Hache du Barbare', 30, 10, 0, 0, 85, 7),
(19, 'Anneau des Éléments', 12, 12, 12, 12, 120, 10),
(20, 'Lance du Dragon', 20, 15, 0, 0, 95, 6);

INSERT INTO ENEMY (IDENEMY, DAMAGE, HEALTH, DESCRIPTION, INTRODUCTION, CONCLUSION)
VALUES
(1, 10, 50, 'Goblin', 'Un gobelin s''approche.', 'Le gobelin a été vaincu.'),
(2, 15, 70, 'Squelette', 'Un squelette apparaît.', 'Le squelette a été détruit.'),
(3, 20, 80, 'Orc', 'Un orc féroce vous attaque.', 'L''orc gît au sol, vaincu.'),
(4, 25, 100, 'Loup des Ténèbres', 'Un loup noir surgit des ombres.', 'Le loup des ténèbres est vaincu.'),
(5, 30, 120, 'Sorcier Malfaisant', 'Un sorcier sombre lance des malédictions.', 'Le sorcier malfaisant est vaincu.'),
(6, 18, 90, 'Harpie', 'Une harpie fond sur vous avec ses serres aiguisées.', 'La harpie est vaincue.'),
(7, 22, 110, 'Golem de Pierre', 'Un imposant golem de pierre se dresse devant vous.', 'Le golem de pierre est détruit.'),
(8, 28, 150, 'Banshee', 'La banshee pleure une mélodie sinistre.', 'La banshee a été apaisée.'),
(9, 32, 130, 'Minotaure', 'Un minotaure puissant charge avec sa hache massive.', 'Le minotaure succombe à la bataille.'),
(10, 35, 180, 'Dragon des Ombres', 'Les yeux brillants du dragon des ombres vous fixent.', 'Le dragon des ombres est terrassé.'),
(11, 15, 60, 'Chauve-souris Vampire', 'Une chauve-souris vampire fond sur vous.', 'La chauve-souris vampire est éliminée.'),
(12, 20, 75, 'Liche Malefique', 'Une liche invoque des forces obscures.', 'La liche est vaincue.'),
(13, 27, 95, 'Serpent Venimeux', 'Un serpent venimeux siffle et attaque.', 'Le serpent venimeux a été éliminé.'),
(14, 30, 110, 'Spectre Glacial', 'Un spectre glacial émane une aura de froid.', 'Le spectre glacial est dissipé.'),
(15, 40, 140, 'Hydre Infernale', 'Une hydre à plusieurs têtes crache des flammes.', 'L''hydre infernale est vaincue.'),
(16, 18, 80, 'Gargouille Pétrifiante', 'Une gargouille pétrifiante se réveille.', 'La gargouille pétrifiante est réduite en morceaux.'),
(17, 24, 120, 'Démon des Abysses', 'Un démon surgit des abysses pour vous défier.', 'Le démon des abysses est banni.'),
(18, 28, 160, 'Phoenix Sombre', 'Un phoenix sombre engloutit tout de ses flammes noires.', 'Le phoenix sombre est anéanti.'),
(19, 22, 100, 'Chimère Féroce', 'Une chimère féroce rugit et attaque.', 'La chimère féroce est terrassée.'),
(20, 38, 200, 'Titan Colossal', 'Un titan colossal ébranle le sol de ses pas.', 'Le titan colossal est vaincu.');

INSERT INTO ENEMYDROP (IDENEMY, IDITEM, QUANTITY)
VALUES
(1, 1, 1),
(2, 3, 2),
(3, 5, 1),
(4, 7, 1),
(5, 10, 1),
(6, 12, 1),
(7, 15, 2),
(8, 18, 1),
(9, 20, 1),
(11, 2, 1),
(12, 8, 1),
(13, 11, 1),
(14, 14, 1),
>>>>>>> c9484ed (first commit)
(15, 17, 1);