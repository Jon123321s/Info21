-- 1. Таблица Peers
CREATE TABLE IF NOT EXISTS Peers (
    Nickname VARCHAR PRIMARY KEY,
    Birthday DATE NOT NULL
);

-- 2. Таблица Tasks
CREATE TABLE IF NOT EXISTS Tasks (
    Title VARCHAR PRIMARY KEY,
    ParentTask VARCHAR,
    MaxXP INTEGER NOT NULL CHECK (MaxXP > 0),
    FOREIGN KEY (ParentTask) REFERENCES Tasks(Title)
);

-- 3. Таблица Checks
CREATE TABLE IF NOT EXISTS Checks (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Peer VARCHAR NOT NULL,
    Task VARCHAR NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname),
    FOREIGN KEY (Task) REFERENCES Tasks(Title)
);

-- 4. Таблица P2P
CREATE TABLE IF NOT EXISTS P2P (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CheckID INTEGER NOT NULL,
    CheckingPeer VARCHAR NOT NULL,
    State VARCHAR NOT NULL CHECK (State IN ('Start', 'Success', 'Failure')),
    Time TIME NOT NULL,
    FOREIGN KEY (CheckID) REFERENCES Checks(ID) ON DELETE CASCADE,
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname)
);

-- 5. Таблица Verter
CREATE TABLE IF NOT EXISTS Verter (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CheckID INTEGER NOT NULL,
    State VARCHAR NOT NULL CHECK (State IN ('Start', 'Success', 'Failure')),
    Time TIME NOT NULL,
    FOREIGN KEY (CheckID) REFERENCES Checks(ID) ON DELETE CASCADE
);

-- 6. Таблица TransferredPoints
CREATE TABLE IF NOT EXISTS TransferredPoints (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CheckingPeer VARCHAR NOT NULL,
    CheckedPeer VARCHAR NOT NULL,
    PointsAmount INTEGER NOT NULL DEFAULT 1 CHECK (PointsAmount >= 0),
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname),
    FOREIGN KEY (CheckedPeer) REFERENCES Peers(Nickname)
);

-- 7. Таблица Friends
CREATE TABLE IF NOT EXISTS Friends (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Peer1 VARCHAR NOT NULL,
    Peer2 VARCHAR NOT NULL,
    FOREIGN KEY (Peer1) REFERENCES Peers(Nickname),
    FOREIGN KEY (Peer2) REFERENCES Peers(Nickname),
    CHECK (Peer1 <> Peer2)
);

-- 8. Таблица Recommendations
CREATE TABLE IF NOT EXISTS Recommendations (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Peer VARCHAR NOT NULL,
    RecommendedPeer VARCHAR NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname),
    FOREIGN KEY (RecommendedPeer) REFERENCES Peers(Nickname),
    CHECK (Peer <> RecommendedPeer)
);

-- 9. Таблица XP
CREATE TABLE IF NOT EXISTS XP (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CheckID INTEGER NOT NULL,
    XPAmount INTEGER NOT NULL CHECK (XPAmount > 0),
    FOREIGN KEY (CheckID) REFERENCES Checks(ID) ON DELETE CASCADE
);

-- 10. Таблица TimeTracking
CREATE TABLE IF NOT EXISTS TimeTracking (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Peer VARCHAR NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    State INTEGER NOT NULL CHECK (State IN (1, 2)),
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname)
);

-- Индексы для оптимизации
CREATE INDEX IF NOT EXISTS idx_checks_peer ON Checks(Peer);
CREATE INDEX IF NOT EXISTS idx_checks_task ON Checks(Task);
CREATE INDEX IF NOT EXISTS idx_p2p_checkid ON P2P(CheckID);
CREATE INDEX IF NOT EXISTS idx_verter_checkid ON Verter(CheckID);
CREATE INDEX IF NOT EXISTS idx_xp_checkid ON XP(CheckID);
CREATE INDEX IF NOT EXISTS idx_timetracking_peer_date ON TimeTracking(Peer, Date);

-- Тестовые данные
INSERT OR IGNORE INTO Peers (Nickname, Birthday) VALUES
('john', '1995-03-15'),
('mary', '1996-07-22'),
('bob', '1997-11-30'),
('alice', '1998-05-10'),
('charlie', '1999-09-05'),
('diana', '2000-01-12'),
('eve', '2001-03-25'),
('frank', '2002-08-08');

INSERT OR IGNORE INTO Tasks (Title, ParentTask, MaxXP) VALUES
('C2_SimpleBashUtils', NULL, 250),
('C3_s21_string+', 'C2_SimpleBashUtils', 500),
('C4_s21_math', 'C2_SimpleBashUtils', 300),
('C5_s21_decimal', 'C4_s21_math', 350),
('C6_s21_matrix', 'C5_s21_decimal', 200),
('C7_SmartCalc_v1.0', 'C3_s21_string+', 600),
('CPP1_s21_matrix+', 'C6_s21_matrix', 400);

INSERT OR IGNORE INTO Checks (Peer, Task, Date) VALUES
('john', 'C2_SimpleBashUtils', '2024-01-10'),
('mary', 'C2_SimpleBashUtils', '2024-01-11'),
('bob', 'C3_s21_string+', '2024-01-12'),
('alice', 'C4_s21_math', '2024-01-13'),
('charlie', 'C5_s21_decimal', '2024-01-14'),
('diana', 'C6_s21_matrix', '2024-01-15'),
('eve', 'C7_SmartCalc_v1.0', '2024-01-16');

INSERT OR IGNORE INTO P2P (CheckID, CheckingPeer, State, Time) VALUES
(1, 'mary', 'Start', '10:00:00'),
(1, 'mary', 'Success', '10:30:00'),
(2, 'john', 'Start', '11:00:00'),
(2, 'john', 'Success', '11:45:00'),
(3, 'alice', 'Start', '14:00:00'),
(3, 'alice', 'Success', '15:00:00'),
(4, 'bob', 'Start', '16:00:00'),
(4, 'bob', 'Success', '16:30:00'),
(5, 'diana', 'Start', '09:00:00'),
(5, 'diana', 'Success', '10:00:00'),
(6, 'eve', 'Start', '13:00:00'),
(6, 'eve', 'Success', '14:30:00');

INSERT OR IGNORE INTO Verter (CheckID, State, Time) VALUES
(1, 'Start', '10:35:00'),
(1, 'Success', '10:40:00'),
(2, 'Start', '11:50:00'),
(2, 'Success', '11:55:00'),
(3, 'Start', '15:05:00'),
(3, 'Success', '15:10:00');

INSERT OR IGNORE INTO TransferredPoints (CheckingPeer, CheckedPeer, PointsAmount) VALUES
('mary', 'john', 1),
('john', 'mary', 1),
('alice', 'bob', 1),
('bob', 'alice', 1),
('diana', 'charlie', 1),
('eve', 'diana', 1),
('frank', 'eve', 2),
('john', 'bob', 1);

INSERT OR IGNORE INTO Friends (Peer1, Peer2) VALUES
('john', 'mary'),
('john', 'bob'),
('mary', 'alice'),
('bob', 'charlie'),
('diana', 'eve'),
('eve', 'frank');

INSERT OR IGNORE INTO Recommendations (Peer, RecommendedPeer) VALUES
('john', 'mary'),
('john', 'bob'),
('mary', 'john'),
('bob', 'alice'),
('alice', 'charlie'),
('charlie', 'diana'),
('diana', 'eve'),
('eve', 'frank');

INSERT OR IGNORE INTO XP (CheckID, XPAmount) VALUES
(1, 250),
(2, 250),
(3, 500),
(4, 300);

INSERT OR IGNORE INTO TimeTracking (Peer, Date, Time, State) VALUES
('john', '2024-01-10', '09:00:00', 1),
('john', '2024-01-10', '18:00:00', 2),
('john', '2024-01-10', '19:00:00', 1),
('john', '2024-01-10', '23:00:00', 2),
('mary', '2024-01-11', '09:30:00', 1),
('mary', '2024-01-11', '20:30:00', 2),
('bob', '2024-01-12', '10:00:00', 1),
('bob', '2024-01-12', '19:00:00', 2),
('alice', '2024-01-13', '08:45:00', 1),
('alice', '2024-01-13', '17:30:00', 2),
('charlie', '2024-01-14', '10:15:00', 1),
('charlie', '2024-01-14', '21:45:00', 2);
