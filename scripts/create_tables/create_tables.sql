CREATE TABLE IF NOT EXISTS circuits (
    circuitId   SERIAL NOT NULL PRIMARY KEY,
    circuitRef  VARCHAR(40),
    name        VARCHAR(40),
    location    VARCHAR(40),
    country     VARCHAR(40),
    lat         REAL,
    lng         REAL,
    alt         INTEGER,
    url         VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS races (
    raceId      SERIAL NOT NULL PRIMARY KEY,
    year        INTEGER,
    round       INTEGER,
    circuitId   INTEGER NOT NULL REFERENCES circuits(circuitId),
    name        VARCHAR(40),
    date        DATE,
    time        TIME,
    url         VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS drivers (
    driverId        SERIAL NOT NULL PRIMARY KEY,
    driverRef       VARCHAR(40),
    number          INTEGER,
    code            VARCHAR(40),
    forename        VARCHAR(40),
    surname         VARCHAR(40),
    dob             DATE,
    nationality     VARCHAR(40),
    url             VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS driver_standings (
    driverStandingsId   BIGSERIAL NOT NULL PRIMARY KEY,
    raceId              INTEGER NOT NULL REFERENCES races(raceId),
    driverId            INTEGER NOT NULL REFERENCES drivers(driverId),
    points              REAL,
    position            INTEGER,
    positionText        VARCHAR(40),
    wins                INTEGER
);
CREATE TABLE IF NOT EXISTS constructors (
    constructorId   SERIAL NOT NULL PRIMARY KEY,
    constructorRef  VARCHAR(40),
    name            VARCHAR(40),
    nationality     VARCHAR(40),
    url             VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS status (
    statusId    SERIAL NOT NULL PRIMARY KEY,
    status      VARCHAR(40)
);
CREATE TABLE IF NOT EXISTS results (
    resultId            BIGSERIAL NOT NULL PRIMARY KEY,
    raceId              INTEGER NOT NULL REFERENCES races(raceId),
    driverId            INTEGER NOT NULL REFERENCES drivers(driverId),
    constructorId       INTEGER NOT NULL REFERENCES constructors(constructorId),
    number              INTEGER,
    grid                INTEGER,
    position            INTEGER,
    positionText        VARCHAR(40),
    positionOrder       VARCHAR(40),
    points              REAL,
    laps                INTEGER,
    time                TIME,
    milliseconds        INTEGER,
    fastestLap          VARCHAR(40),
    rank                INTEGER,
    fastestLapTime      TIME,
    fastestLapSpeed     REAL,
    statusId            INTEGER REFERENCES status(statusId)
);
CREATE TABLE IF NOT EXISTS constructor_standings (
    constructorStandingsId  SERIAL NOT NULL PRIMARY KEY,
    raceId                  INTEGER NOT NULL REFERENCES races(raceId),
    constructorId           INTEGER NOT NULL REFERENCES constructors(constructorId),
    points                  REAL,
    position                INTEGER,
    positionText            VARCHAR(40),
    wins                    INTEGER
);
CREATE TABLE IF NOT EXISTS constructor_results (
    constructorResultsId    BIGSERIAL NOT NULL PRIMARY KEY,
    raceId                  INTEGER NOT NULL REFERENCES races(raceId),
    constructorId           INTEGER NOT NULL REFERENCES constructors(constructorId),
    points                  REAL,
    status                  VARCHAR(40)
);
CREATE TABLE IF NOT EXISTS laptimes (
    raceId          INTEGER NOT NULL REFERENCES races(raceId),
    driverId        INTEGER NOT NULL REFERENCES drivers(driverId),
    lap             INTEGER NOT NULL,
    position        INTEGER,
    time            TIME,
    milliseconds    INTEGER,
    PRIMARY KEY (raceId, driverId, lap)
);
CREATE TABLE IF NOT EXISTS pitstops (
    raceId          INTEGER NOT NULL REFERENCES races(raceId),
    driverId        INTEGER NOT NULL REFERENCES drivers(driverId),
    stop            INTEGER NOT NULL,
    lap             INTEGER,
    time            TIME,
    duration        TIME,
    milliseconds    INTEGER,
    PRIMARY KEY (raceId, driverId, stop)
);
CREATE TABLE IF NOT EXISTS qualifying (
    qualifyId       BIGSERIAL NOT NULL PRIMARY KEY,
    raceId          INTEGER NOT NULL REFERENCES races(raceId),
    driverId        INTEGER NOT NULL REFERENCES drivers(driverId),
    constructorId   INTEGER NOT NULL REFERENCES constructors(constructorId),
    number          INTEGER,
    position        INTEGER,
    q1              TIME,
    q2              TIME,
    q3              TIME
);
CREATE TABLE IF NOT EXISTS seasons (
    year    INTEGER NOT NULL PRIMARY KEY,
    url     VARCHAR(200)
);