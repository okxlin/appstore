insert or replace into todos(id, title)
select $todo_id, :todo
where :todo is not null
returning
    'redirect' as component,
    '/' as link;

select 'dynamic' as component, sqlpage.run_sql('shell.sql') as properties;

select
    'form' as component,
    'Todo' as title,
    case when $todo_id is null then
        'Add new todo'
    else
        'Edit todo'
    end as validate;
select
    'Todo item' as label,
    'todo' as name,
    'What do you have to do?' as placeholder,
    (select title from todos where id = $todo_id) as value;
