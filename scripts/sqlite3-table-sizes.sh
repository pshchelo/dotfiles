#!/usr/bin/env bash
db=$1
echo "SELECT 'SELECT count(*) \"' || name || '\" FROM ' || name || ';'  FROM sqlite_master WHERE type = 'table';" |
    sqlite3 -readonly "$db" | sqlite3 -readonly -line "$db"
