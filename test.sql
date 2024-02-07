CREATE DATABASE QLBD_AT19N0135
GO
USE QLBD_AT19N0135
DROP TABLE IF EXISTS San;
DROP TABLE IF EXISTS Doi;
DROP TABLE IF EXISTS TranDau;
DROP TABLE IF EXISTS CT_TranDau;
CREATE TABLE San(
    MaSan VARCHAR(255) PRIMARY KEY,
    TenSan VARCHAR(255),
    DiaChi VARCHAR(255)
);

-- Tạo bảng Doi
CREATE TABLE Doi(
    MaDoi VARCHAR(255) PRIMARY KEY,
    TenDoi VARCHAR(255),
    MaSan VARCHAR(255),
    FOREIGN KEY (MaSan) REFERENCES San(MaSan)
);

-- Tạo bảng TranDau
CREATE TABLE TranDau(
    MaTD VARCHAR(255) PRIMARY KEY,
    MaSan VARCHAR(255),
    Ngay DATE,
    Gio TIME,
    FOREIGN KEY (MaSan) REFERENCES San(MaSan)
);

-- Tạo bảng CT_TranDau
CREATE TABLE CT_TranDau(
    MaTD VARCHAR(255),
    MaDoi VARCHAR(255),
    SoBanThang INT CHECK (SoBanThang >= 0),
    PRIMARY KEY (MaTD, MaDoi),
    FOREIGN KEY (MaTD) REFERENCES TranDau(MaTD),
    FOREIGN KEY (MaDoi) REFERENCES Doi(MaDoi)
);

-- Chèn dữ liệu vào bảng San
INSERT INTO San(MaSan, TenSan, DiaChi) VALUES
('MDI', 'Mỹ Đình', 'Hà Nội – Việt Nam'),
('NAS', 'Sân vận động quốc gia Viêng Chăn', 'Lào'),
('IMO', 'Sân I-Mobile Buriram', 'Thái Lan'),
('MOD', 'Khu thể thao Morodok Decho Russey Keo', 'Campuchia');

-- Chèn dữ liệu vào bảng Doi
INSERT INTO Doi(MaDoi, TenDoi, MaSan) VALUES
('VN', 'Việt Nam', 'MDI'),
('LA', 'Lào', 'NAS'),
('TL', 'Thái Lan', 'IMO'),
('CPC', 'Campuchia', 'MOD');

-- Chèn dữ liệu vào bảng TranDau
INSERT INTO TranDau(MaTD, MaSan, Ngay, Gio) VALUES
('01', 'MOD', '14/08/2017', '15:00'),
('02', 'NAS', '16/08/2017', '17:00'),
('03', 'MOD', '16/08/2017', '15:00'),
('04', 'IMO', '18/08/2017', '19:00');

-- Chèn dữ liệu vào bảng CT_TranDau
INSERT INTO CT_TranDau(MaTD, MaDoi, SoBanThang) VALUES
('01', 'VN', 3),
('01', 'TL', 1),
('02', 'VN', 5),
('02', 'LA', 0),
('03', 'TL', 3),
('03', 'CPC', 3),
('04', 'TL', 2),
('04', 'LA', 0);
 --Câu 1: In số trận đấu mà mỗi đội đã thi đấu. Hiển thị: MaDoi, TenDoi.
 --Câu 1: 
SELECT Doi.MaDoi, Doi.TenDoi, COUNT(CT_TranDau.MaTD) as SoTranDau
FROM Doi
LEFT JOIN CT_TranDau ON Doi.MaDoi = CT_TranDau.MaDoi
GROUP BY Doi.MaDoi, Doi.TenDoi;

-- Câu 2: 
SELECT
    TranDau.MaTD AS MaTran,
    CONCAT(Doi2.TenDoi, '-', Doi1.TenDoi) AS 'DoiTranDau',
    CONCAT(CT_TranDau2.SoBanThang, '-', CT_TranDau1.SoBanThang) AS 'TySo'
FROM TranDau
JOIN CT_TranDau CT_TranDau1 ON TranDau.MaTD = CT_TranDau1.MaTD
JOIN Doi Doi1 ON CT_TranDau1.MaDoi = Doi1.MaDoi
JOIN CT_TranDau CT_TranDau2 ON TranDau.MaTD = CT_TranDau2.MaTD AND CT_TranDau1.MaDoi < CT_TranDau2.MaDoi
JOIN Doi Doi2 ON CT_TranDau2.MaDoi = Doi2.MaDoi;

-- Câu 3: 
SELECT
    TranDau.MaTD AS MaTran,
    Doi.TenDoi AS Doi,
    CASE
        WHEN CT_TranDau1.SoBanThang > CT_TranDau2.SoBanThang THEN 3
        WHEN CT_TranDau1.SoBanThang = CT_TranDau2.SoBanThang THEN 1
        ELSE 0
    END AS Diem
FROM TranDau
JOIN CT_TranDau CT_TranDau1 ON TranDau.MaTD = CT_TranDau1.MaTD
JOIN Doi ON CT_TranDau1.MaDoi = Doi.MaDoi
JOIN CT_TranDau CT_TranDau2 ON TranDau.MaTD = CT_TranDau2.MaTD AND CT_TranDau1.MaDoi != CT_TranDau2.MaDoi;

-- Câu 4: 
SELECT
    Doi.MaDoi,
    Doi.TenDoi,
    SUM(
        CASE
            WHEN CT_TranDau1.SoBanThang > CT_TranDau2.SoBanThang THEN 3
            WHEN CT_TranDau1.SoBanThang = CT_TranDau2.SoBanThang THEN 1
            ELSE 0
        END
    ) AS TongDiem
FROM Doi
LEFT JOIN CT_TranDau CT_TranDau1 ON Doi.MaDoi = CT_TranDau1.MaDoi
LEFT JOIN TranDau ON CT_TranDau1.MaTD = TranDau.MaTD
LEFT JOIN CT_TranDau CT_TranDau2 ON TranDau.MaTD = CT_TranDau2.MaTD AND CT_TranDau1.MaDoi != CT_TranDau2.MaDoi
GROUP BY Doi.MaDoi, Doi.TenDoi
ORDER BY TongDiem DESC;

-- Câu 5: 
SELECT
    Doi.MaDoi,
    Doi.TenDoi,
    SUM(
        CASE
            WHEN CT_TranDau1.SoBanThang > CT_TranDau2.SoBanThang THEN 3
            WHEN CT_TranDau1.SoBanThang = CT_TranDau2.SoBanThang THEN 1
            ELSE 0
        END
    ) AS TongDiem,
    SUM(CT_TranDau1.SoBanThang - CT_TranDau2.SoBanThang) AS HieuSo
FROM Doi
LEFT JOIN CT_TranDau CT_TranDau1 ON Doi.MaDoi = CT_TranDau1.MaDoi
LEFT JOIN TranDau ON CT_TranDau1.MaTD = TranDau.MaTD
LEFT JOIN CT_TranDau CT_TranDau2 ON TranDau.MaTD = CT_TranDau2.MaTD AND CT_TranDau1.MaDoi != CT_TranDau2.MaDoi
GROUP BY Doi.MaDoi, Doi.TenDoi
ORDER BY TongDiem DESC, HieuSo DESC;
-- Câu 6


