require 'active_record'

TEST_DB_PATH = '/home/marko/dumper/test_dumper.sqlite3'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: TEST_DB_PATH)
