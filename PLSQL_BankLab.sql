SET SERVEROUTPUT ON

DELETE FROM jrock.account_profile_mjv893;
/

CREATE OR REPLACE PACKAGE account_manager_pkg_mjv893 IS
------------------------------
PROCEDURE calculate_account_profiles;
------------------------------
FUNCTION get_account_profile_record
(p_demographic_profile_id IN NUMBER)
RETURN jrock.account_demographic_profiles%ROWTYPE;
------------------------------
FUNCTION get_account_profile_record
(p_age IN NUMBER
,p_gender IN VARCHAR2
,p_income IN NUMBER
,p_marital_status IN VARCHAR2
,p_child_status IN VARCHAR2)
RETURN jrock.account_demographic_profiles%ROWTYPE;
------------------------------
PROCEDURE print_demographic_profile
(p_demographic_profile_id IN NUMBER);
------------------------------
PROCEDURE print_top_n_stats
(p_top_n NUMBER DEFAULT 5);
------------------------------
END;
/

CREATE OR REPLACE PACKAGE BODY account_manager_pkg_mjv893 IS
------------------------------
PROCEDURE calculate_account_profiles IS
    v_account_profile_record jrock.account_demographic_profiles%ROWTYPE;
BEGIN
    FOR item IN (
        SELECT account_holder_id, account_holder_age, account_holder_gender, account_holder_income, account_holder_marital_status, account_holder_child_status
            FROM jrock.account_holders
    ) LOOP      
        v_account_profile_record := get_account_profile_record(item.account_holder_age, item.account_holder_gender, item.account_holder_income, item.account_holder_marital_status, item.account_holder_child_status);
            
        INSERT INTO jrock.account_profile_mjv893 
        (account_holder_id, demographic_profile_id) VALUES
        (item.account_holder_id, v_account_profile_record.demographic_profile_id);
    END LOOP;
END;
------------------------------
FUNCTION get_account_profile_record
(p_demographic_profile_id IN NUMBER)
RETURN jrock.account_demographic_profiles%ROWTYPE IS
    v_account_profile_record jrock.account_demographic_profiles%ROWTYPE;
BEGIN
    SELECT * 
        INTO v_account_profile_record
        FROM jrock.account_demographic_profiles
        WHERE demographic_profile_id = p_demographic_profile_id;
    RETURN v_account_profile_record;
END;
------------------------------
FUNCTION get_account_profile_record
(p_age IN NUMBER
,p_gender IN VARCHAR2
,p_income IN NUMBER
,p_marital_status IN VARCHAR2
,p_child_status IN VARCHAR2)
RETURN jrock.account_demographic_profiles%ROWTYPE IS
    v_age_min jrock.account_demographic_profiles.age_min%TYPE;
    v_age_max jrock.account_demographic_profiles.age_max%TYPE;
    v_gender jrock.account_demographic_profiles.gender%TYPE;
    v_income jrock.account_demographic_profiles.income_band%TYPE;
    v_marital_status jrock.account_demographic_profiles.marital_status%TYPE;
    v_child_status jrock.account_demographic_profiles.child_status%TYPE;
    v_account_profile_record jrock.account_demographic_profiles%ROWTYPE;
BEGIN
    IF (MOD(p_age, 10) = 0) THEN
        v_age_min := p_age;
        v_age_max := (p_age + 10) - 1;
    ELSE
        v_age_min := FLOOR(p_age / 10) * 10;
        v_age_max := CEIL(p_age / 10) * 10 - 1;
    END IF;
    
    v_gender := UPPER(SUBSTR(LTRIM(RTRIM(p_gender)), 1, 1));
    
    IF (p_income >= 60000) THEN
        v_income := 'HIGH';
    ELSE
        v_income := 'LOW';
    END IF;
    
    IF (UPPER(LTRIM(RTRIM(p_marital_status))) = 'MARRIED') THEN
        v_marital_status := 'M';
    ELSE
        v_marital_status := 'S';
    END IF;
    
    v_child_status := UPPER(SUBSTR(LTRIM(RTRIM(p_child_status)), 1, 1));

    SELECT * 
        INTO v_account_profile_record
        FROM jrock.account_demographic_profiles
        WHERE age_min = v_age_min
                AND age_max = v_age_max
                AND gender = v_gender
                AND income_band = v_income
                AND marital_status = v_marital_status
                AND child_status = v_child_status;
    RETURN v_account_profile_record;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        SELECT * 
            INTO v_account_profile_record
            FROM jrock.account_demographic_profiles
            WHERE demographic_profile_id = -1;
        RETURN v_account_profile_record;
END;
------------------------------
PROCEDURE print_demographic_profile
(p_demographic_profile_id IN NUMBER) IS
    v_demographic_profile jrock.account_demographic_profiles%ROWTYPE;
BEGIN
    v_demographic_profile := get_account_profile_record(p_demographic_profile_id);
    DBMS_OUTPUT.PUT('id: ' || v_demographic_profile.demographic_profile_id);
    DBMS_OUTPUT.PUT(', age: ' || v_demographic_profile.age_min);
    DBMS_OUTPUT.PUT('-' || v_demographic_profile.age_max);
    DBMS_OUTPUT.PUT(', gender: ' || v_demographic_profile.gender);
    DBMS_OUTPUT.PUT(', income: ' || v_demographic_profile.income_band);
    DBMS_OUTPUT.PUT(', marital: ' || v_demographic_profile.marital_status);
    DBMS_OUTPUT.PUT_LINE(', child: ' || v_demographic_profile.child_status);
END;
------------------------------
PROCEDURE print_top_n_stats
(p_top_n NUMBER DEFAULT 5) IS
    v_top_n NUMBER := p_top_n;
BEGIN
    IF (v_top_n >= 1 AND v_top_n <= 25) THEN
        DBMS_OUTPUT.PUT_LINE('Top ' || v_top_n || ' Stats:');
        DBMS_OUTPUT.PUT_LINE('----------------------------');
        
        FOR item IN (
            SELECT *
                FROM (
                SELECT demographic_profile_id, count(demographic_profile_id) AS count
                    FROM jrock.account_profile_mjv893
                    GROUP BY demographic_profile_id
                    ORDER BY count(demographic_profile_id) DESC)
                WHERE ROWNUM < (v_top_n + 1)
        ) LOOP                      
            DBMS_OUTPUT.PUT('count: ' || item.count || ' ');
            print_demographic_profile(item.demographic_profile_id);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------');
    ELSE
        v_top_n := 5;
        
        DBMS_OUTPUT.PUT_LINE('Top ' || v_top_n || ' Stats:');
        DBMS_OUTPUT.PUT_LINE('----------------------------');
        
        FOR item IN (
            SELECT *
                FROM (
                SELECT demographic_profile_id, count(demographic_profile_id) AS count
                    FROM jrock.account_profile_mjv893
                    GROUP BY demographic_profile_id
                    ORDER BY count(demographic_profile_id) DESC)
                WHERE ROWNUM < (v_top_n + 1)
        ) LOOP                      
            DBMS_OUTPUT.PUT('count: ' || item.count || ' ');
            print_demographic_profile(item.demographic_profile_id);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------');
    END IF;
END;
------------------------------
END;
/

/*
--test cases
DECLARE
    v_account_profile_record jrock.account_demographic_profiles%ROWTYPE;
BEGIN
    account_manager_pkg_mjv893.calculate_account_profiles;
    
    v_account_profile_record := account_manager_pkg_mjv893.get_account_profile_record(1);
    DBMS_OUTPUT.PUT_LINE('demographic profile id: ' || v_account_profile_record.demographic_profile_id);
    
    v_account_profile_record := account_manager_pkg_mjv893.get_account_profile_record(51, 'F', 67440, 'Married', 'Yes');
    DBMS_OUTPUT.PUT_LINE('demographic profile id: ' || v_account_profile_record.demographic_profile_id);
    
    account_manager_pkg_mjv893.print_demographic_profile(v_account_profile_record.demographic_profile_id);
    
    account_manager_pkg_mjv893.print_top_n_stats(2);
END;
/
*/