class CreateStripeInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_invoices do |t|
      t.string :invoice_uid
      t.integer :amount_due
      t.string :billing_reason
      t.integer :created
      t.string :customer_uid
      t.text :hosted_invoice_url
      t.string :subscription_uid
      t.string :status

      t.timestamps
    end

    add_index :stripe_invoices, :invoice_uid, unique: true
  end
end
