class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name

      t.string :insurance_number, length: 64
      t.string :post_code, lenght: 16

      t.inet :registered_from
      t.st_point :current_location, geographic: true

      t.text :about
    end

    add_indexes
  end

  def down
    drop_table :users
  end

  private

  def add_indexes
    # b-tree index
    add_index :users, :first_name

    # gist index
    add_index :users, :current_location, using: :gist

    # gin index
    execute <<-SQL
      CREATE INDEX users_about_fulltext_idx ON users USING gin(to_tsvector('english', about));
    SQL

    # hash index
    add_index :users, :insurance_number, using: :hash

    # brin index
    add_index :users, :registered_from, using: :brin

    # clustering
    execute <<-SQL
      CLUSTER users USING index_users_on_first_name;
    SQL

    # functional index
    execute <<-SQL
      CREATE INDEX users_full_name_idx ON users ((first_name || ' ' || last_name));
    SQL
  end
end
