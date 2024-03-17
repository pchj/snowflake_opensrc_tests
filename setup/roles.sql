begin;

    use role accountadmin;
    /* Create variables for user, password, role, warehouse, database, and schema (needs to be uppercase for objects) */
    set role_name = 'OPENSRC';
    set user_name = 'DATA_USER';
    set warehouse_name = 'DATALING';

    /* Must be at least 8 characters long, contain at least 1 digit, 1 uppercase letter and 1 lowercase letter */
    set user_password = '';               /* Replace with a strong password */
    set database_name = 'ANALYTICS';      /* Replace with your Snowflake database name */
    set schema_name = 'ANALYTICS.PUBLIC'; /*Snowflake schema name */
    /* Grant sysadmin role access to the database */
    grant usage,modify
    on database identifier($database_name)
    to role sysadmin;

    /* Grant sysadmin role access to the schema */
    grant usage,modify
    on schema identifier($schema_name)
    to role sysadmin;

    /* Change role to securityadmin for user / role steps */
    use role securityadmin;

    /* Create a role for DATA */
    create role if not exists identifier($role_name);
    grant role identifier($role_name) to role SYSADMIN;

     /* Change role to sysadmin for warehouse and database steps */
    use role sysadmin;

    /* Create a warehouse for DATA */
    create warehouse if not exists identifier($warehouse_name)
    warehouse_size = xsmall
    warehouse_type = standard
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true;

    /* Change role to securityadmin for user / role steps */
    use role securityadmin;

    /* Create a user for DATA */
    create user if not exists identifier($user_name)
    password = $user_password
    default_role = $role_name
    default_warehouse = $warehouse_name;

    grant role identifier($role_name) to user identifier($user_name);

    /* Change role to accountadmin for warehouse and database steps */
    use role accountadmin;

    /* Grant DATA role access to the warehouse */
    grant usage, monitor
    on warehouse identifier($warehouse_name)
    to role identifier($role_name);

    /* Grant DATA role access to the database */
    grant usage, monitor
    on database identifier($database_name)
    to role identifier($role_name);

    /* Grant DATA role access to the schema */
    grant create procedure, create stage, create task, create stream, usage
    on schema identifier($schema_name)
    to role identifier($role_name);

    /* Grant DATA role select on all tables in the schema */
    grant select on all tables
    in schema identifier($schema_name)
    to role identifier($role_name);

    /* Grant DATA role select on all future tables in the schema */
    grant select on future tables
    in schema identifier($schema_name)
    to role identifier($role_name);

    grant execute task on account
    to role identifier($role_name);

commit;
