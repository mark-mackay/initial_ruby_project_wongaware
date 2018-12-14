require_relative( "../models/tag.rb" )
require_relative( "../models/merchant.rb" )
require_relative( "../models/transaction.rb" )
require("pry-byebug")

Transaction.delete_all()
Merchant.delete_all()
Tag.delete_all()

merchant1 = Merchant.new({
  'name' => "Amazon"
})

merchant1.save()

merchant2 = Merchant.new({
  'name' => "ScotRail"
})

merchant2.save()

merchant3 = Merchant.new({
  'name' => "Tesco"
})

merchant3.save()

merchant4 = Merchant.new({
  'name' => "Sky"
})

merchant4.save()

merchant5 = Merchant.new({
  'name' => "Three"
})

merchant5.save()

merchant6 = Merchant.new({
  'name' => "M&S"
})

merchant6.save()

tag1 = Tag.new({
  'type' => "Retail"
})

tag1.save()

tag2 = Tag.new({
  'type' => "Transport"
})

tag2.save()

tag3 = Tag.new({
  'type' => "Telecoms"
})

tag3.save()

tag4 = Tag.new({
  'type' => "Home Entertainment"
})

tag4.save()


transaction1 = Transaction.new({
  "merchant_id" => merchant1.id,
  "tag_id" => tag1.id,
  'amount' => 50.55,
  'transaction_time' => "13:32"
})

transaction1.save()

transaction2 = Transaction.new({
  "merchant_id" => merchant2.id,
  "tag_id" => tag2.id,
  'amount' => 134.29,
  'transaction_time' => "07:12"
})

transaction2.save()

transaction3 = Transaction.new({
  "merchant_id" => merchant5.id,
  "tag_id" => tag3.id,
  'amount' => 17.99,
  'transaction_time' => "00:01"
})

transaction3.save()

transaction4 = Transaction.new({
  "merchant_id" => merchant4.id,
  "tag_id" => tag4.id,
  'amount' => 128.88,
  'transaction_time' => "19:56"
})

transaction4.save()

binding.pry
nil
