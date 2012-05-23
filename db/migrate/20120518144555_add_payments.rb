class AddPayments < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :payments, :boolean
    add_column :events, :payment_done, :boolean
    add_column :events, :payment_amount, :string
    add_column :events, :payment_way, :string
    Tournament.all.each {|t|t.payments = false; t.save}
  end

  def self.down
    remove_column :tournaments, :payments
    remove_column :events, :payment_done
    remove_column :events, :payment_amount
    remove_column :events, :payment_way
  end
end
