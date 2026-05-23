-- +goose Up
CREATE SCHEMA company;

CREATE TABLE company.department (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    name VARCHAR(200) NOT NULL CHECK (char_length(TRIM(name)) BETWEEN 1 AND 200),
    parent_id INTEGER DEFAULT NULL,

    CHECK (id != parent_id),

    FOREIGN KEY (parent_id) REFERENCES company.department(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_name
ON company.department (parent_id, name)
WHERE parent_id IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_root
ON company.department (name)
WHERE parent_id IS NULL;

CREATE TABLE company.employee (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (department_id) REFERENCES  company.department(id),
    full_name VARCHAR(200) NOT NULL CHECK (char_length(full_name) BETWEEN 1 AND 200),
    position VARCHAR(200) NOT NULL CHECK (char_length(position) BETWEEN 1 AND 200),
    hired_at DATE DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_employee_department 
ON company.employee (department_id);

-- +goose Down
DROP INDEX IF EXISTS idx_employee_department;

DROP TABLE IF EXISTS company.employee;

DROP INDEX IF EXISTS idx_unique_root; 

DROP INDEX IF EXISTS idx_unique_name;

DROP TABLE IF EXISTS company.department;

DROP SCHEMA IF EXISTS company;