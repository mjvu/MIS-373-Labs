SET SERVEROUTPUT ON

DROP TABLE mjv893_metadata_tbl
/

CREATE TABLE mjv893_metadata_tbl
(setting VARCHAR2(50) 
, context VARCHAR2(2000) 
, value VARCHAR2(100)
)
/

CREATE OR REPLACE PACKAGE metadata AS
------------------------------
PROCEDURE save
(p_setting IN VARCHAR2
,p_context_tbl IN jrock.vbfy_types.t_context_tbl
,p_value IN VARCHAR2);
------------------------------
PROCEDURE remove
(p_setting IN VARCHAR2 DEFAULT NULL);
------------------------------
FUNCTION lookup
(p_setting IN VARCHAR2
,p_context IN VARCHAR2
,p_final_default_value IN VARCHAR2 DEFAULT NULL
,p_check_hierarchy IN NUMBER DEFAULT 1)
RETURN VARCHAR2;
------------------------------
END;
/

CREATE OR REPLACE PACKAGE BODY metadata AS
------------------------------
PROCEDURE save
(p_setting IN VARCHAR2
,p_context_tbl IN jrock.vbfy_types.t_context_tbl
,p_value IN VARCHAR2) IS
    v_setting VARCHAR2(50);
    v_context VARCHAR2(50);
    v_context_tbl VARCHAR2(2000);
    v_value VARCHAR2(100);
BEGIN
    v_setting := UPPER(SUBSTR(LTRIM(RTRIM(p_setting)), 1, 50));
    v_value := TO_CHAR(SUBSTR(LTRIM(RTRIM(p_value)), 1, 100));
    
    FOR i IN p_context_tbl.FIRST..p_context_tbl.LAST LOOP
        v_context := UPPER(SUBSTR(LTRIM(RTRIM(p_context_tbl(i))), 1, 50));
        v_context_tbl := v_context_tbl || UPPER(SUBSTR(LTRIM(RTRIM(v_context)), 1, 2000)) || '-';
    END LOOP;
    
    v_context_tbl := SUBSTR(v_context_tbl, 1, LENGTH(v_context_tbl) - 1);
    
    INSERT INTO mjv893_metadata_tbl
    (setting, context, value) VALUES
    (v_setting, v_context_tbl, v_value);
END;
------------------------------
PROCEDURE remove
(p_setting IN VARCHAR2 DEFAULT NULL) IS
    v_setting mjv893_metadata_tbl.setting%TYPE;
BEGIN
    v_setting := UPPER(SUBSTR(LTRIM(RTRIM(p_setting)), 1, 50));
    DELETE FROM mjv893_metadata_tbl
        WHERE setting = v_setting;
END;
------------------------------
FUNCTION lookup
(p_setting IN VARCHAR2
,p_context IN VARCHAR2
,p_final_default_value IN VARCHAR2 DEFAULT NULL
,p_check_hierarchy IN NUMBER DEFAULT 1)
RETURN VARCHAR2 IS
    v_setting mjv893_metadata_tbl.setting%TYPE;
    v_context mjv893_metadata_tbl.context%TYPE;
    v_context_check NUMBER;
    v_context_match mjv893_metadata_tbl.context%TYPE;
    v_value mjv893_metadata_tbl.value%TYPE;
    v_check_hierarchy NUMBER;
BEGIN
    v_setting := UPPER(SUBSTR(LTRIM(RTRIM(p_setting)), 1, 50));
    v_context := UPPER(SUBSTR(LTRIM(RTRIM(p_context)), 1, 2000));
    v_check_hierarchy := NVL(p_check_hierarchy, 1);
    
    IF (NVL(v_check_hierarchy, 1) NOT IN (0, 1)) THEN
        v_check_hierarchy := 1;
        SELECT value
            INTO v_value
            FROM mjv893_metadata_tbl
            WHERE setting = v_setting
                AND context LIKE v_context || '%';
        RETURN v_value;
    ELSIF (v_check_hierarchy = 0) THEN
        SELECT value
            INTO v_value
            FROM mjv893_metadata_tbl
            WHERE setting = v_setting
                AND context = v_context;
        RETURN v_value;    
    ELSE
        FOR item IN (
            SELECT context, value
                FROM mjv893_metadata_tbl
        ) LOOP      
            v_context_check := INSTR(v_context, item.context);
            IF (v_context_check = 1) THEN
                v_context_match := item.context;
            END IF;
        END LOOP;
        SELECT value
            INTO v_value
            FROM mjv893_metadata_tbl
            WHERE setting = v_setting
                AND context = v_context_match;
        RETURN v_value;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF (p_final_default_value IS NULL) THEN
            RETURN 'NULL';
        ELSE
            RETURN p_final_default_value;
        END IF;
END;
------------------------------
END;
/

/*
--test cases
DECLARE
    v_setting VARCHAR2(50);
    v_context_tbl jrock.vbfy_types.t_context_tbl;
BEGIN
    v_setting := 'SAYING';
    v_context_tbl(1) := 'US';
    metadata.save(v_setting, v_context_tbl, 'Surfin'' USA');
    
    v_context_tbl(2) := 'TX';
    metadata.save(v_setting, v_context_tbl, 'Texas is God''s Country');
    
    v_context_tbl(3) := 'Austin';
    metadata.save(v_setting, v_context_tbl, 'Music Capital of the World');
    
    v_context_tbl(4) := 'Professor';
    metadata.save(v_setting, v_context_tbl, 'Code a Little Test a Little');
    
    v_setting := 'Test';
    v_context_tbl(5) := 'Student';
    metadata.save(v_setting, v_context_tbl, 'Help');
    
    --metadata.remove('Test');
END;
/

SELECT metadata.lookup('SAYING', 'us') FROM dual;
/

SELECT metadata.lookup('SAYING', 'Us-Tx') FROM dual;
/

SELECT metadata.lookup('SAYING', 'US-TX-AuStIn') FROM dual;
/

SELECT metadata.lookup('SAYING', 'US-TX-AUSTIN-PROFESSOR') FROM dual;
/
*/