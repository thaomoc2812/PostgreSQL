CREATE TABLE regions
    ( region_id      SERIAL primary key,
      region_name    VARCHAR(25)
    );

CREATE TABLE countries
    ( country_id      CHAR(2) not null PRIMARY KEY
    , country_name    VARCHAR(40)
    , region_id       INTEGER  REFERENCES regions(region_id)
    );

CREATE TABLE locations
    ( location_id    SERIAL PRIMARY KEY
    , street_address VARCHAR(40)
    , postal_code    VARCHAR(12)
    , city       VARCHAR(30) NOT NULL
    , state_province VARCHAR(25)
    , country_id     CHAR(2) REFERENCES countries (country_id)
    ) ;

CREATE TABLE departments
    ( department_id    SERIAL PRIMARY KEY
    , department_name  VARCHAR(30) NOT NULL
    , manager_id       INTEGER
    , location_id      INTEGER references locations (location_id)
    ) ;

CREATE TABLE jobs
    ( job_id         VARCHAR(10) PRIMARY KEY
    , job_title      VARCHAR(35) NOT NULL
    , min_salary     NUMERIC(6)
    , max_salary     NUMERIC(6)
    ) ;

CREATE TABLE employees
    ( employee_id    SERIAL PRIMARY KEY
    , first_name     VARCHAR(20)
    , last_name      VARCHAR(25) NOT NULL
    , email          VARCHAR(25) NOT NULL
    , phone_number   VARCHAR(20)
    , hire_date      TIMESTAMP  NOT NULL
    , job_id         VARCHAR(10) NOT NULL REFERENCES jobs(job_id)
    , salary         NUMERIC(8,2)
    , commission_pct NUMERIC(2,2)
    , manager_id     INTEGER REFERENCES employees(employee_id)
    , department_id  INTEGER REFERENCES departments(department_id)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0)
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

ALTER TABLE DEPARTMENTS ADD CONSTRAINT dept_mgr_fk
                 FOREIGN KEY (manager_id)
                  REFERENCES employees (employee_id);

CREATE TABLE job_history
    ( employee_id   INTEGER NOT NULL REFERENCES employees(employee_id)
    , start_date    TIMESTAMP NOT NULL
    , end_date      TIMESTAMP NOT NULL
    , job_id        VARCHAR(10) NOT NULL REFERENCES jobs(job_id)
    , department_id INTEGER REFERENCES departments(department_id)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    , PRIMARY KEY (employee_id, start_date)
    ) ;
