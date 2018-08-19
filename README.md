# README

## Unit tests

```ruby
# spec/models/contact_spec.rb:2
require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '.lastest_active_days_of_phones method' do

    subject { Contact.lastest_active_days_of_phones }

    context 'current phone number was de-activated' do
      before do
        Contact.create(phone_number: '0987001', activation_date: '2016-01-01', deactivation_date: '2016-03-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-03-01', deactivation_date: '2016-05-01')
      end

      it 'should NOT invoke it' do
        expect(subject.count).to eq(0)
      end
    end

    context 'current phone number was activated' do
      before do
        Contact.create(phone_number: '0987001', activation_date: '2015-01-01', deactivation_date: '2016-03-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-03-01', deactivation_date: nil)
      end

      it 'should invoke it' do
        expect(subject.count).to eq(1)
        expect(subject.first.activation_date.to_s).to eq('2015-01-01')
      end
    end

    context 'phone number were used by 3 users' do
      before do
        # User-A
        Contact.create(phone_number: '0987001', activation_date: '2016-01-01', deactivation_date: '2016-03-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-03-01', deactivation_date: '2016-05-01')

        # User-B
        Contact.create(phone_number: '0987001', activation_date: '2016-06-01', deactivation_date: '2016-07-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-07-01', deactivation_date: '2016-08-01')

        # User-C current active user
        Contact.create(phone_number: '0987001', activation_date: '2016-08-15', deactivation_date: '2016-09-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-09-01', deactivation_date: '2016-10-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-10-01', deactivation_date: '2016-11-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-11-01', deactivation_date: nil)
      end

      it 'should invoke actual activation date of User-C' do
        expect(subject.count).to eq(1)
        expect(subject.first.activation_date.to_s).to eq('2016-08-15')
      end
    end

    context 'user de-active and re-active 1 month later' do
      it 'was not covered by us' do
        # Pending........... waiting for confirmation
      end
    end
  end
end

```

## I - Implement actual activation date logic

#### 1 - Select current active phones with **activation_date**

```sql
### COMMENTS: active phones with activation_date column
 SELECT
   c1.id,
   c1.phone_number,
   c1.activation_date
 FROM contacts c1
   JOIN (SELECT
           phone_number,
           sum(IF(deactivation_date IS NULL, 1, 0)) count_active
         FROM contacts
         GROUP BY phone_number
         HAVING count_active > 0
        ) active_c ON active_c.phone_number = c1.phone_number
```

#### 2 - Select current active phones with **deactivation_date**

```sql
### COMMENTS: active phones with deactivation_date column
 SELECT
   c1.id,
   c1.phone_number,
   c1.deactivation_date
 FROM contacts c1
   JOIN (SELECT
           phone_number,
           sum(IF(deactivation_date IS NULL, 1, 0)) count_active
         FROM contacts
         GROUP BY phone_number
         HAVING count_active > 0
        ) active_c ON active_c.phone_number = c1.phone_number
 WHERE c1.deactivation_date IS NOT NULL
```

#### 3 - Use **UNION ALL** to merge activation_date and deactivation_date

#### 4 - actual action date are columns

- 1) **Group by phone number**
- 2) deactivation_date and activation_date are counted = 1 which is row describe actual activation date **(Because it break in amount of time. So they were not de-activated by switch user)**
- 3) Get **max(results.activation_date) as activation_date** will get latest actual activation_date


## Implement by Ruby on Rails

#### 1 - Write full test for model
#### 2 - Parse sql_query to Contact model
#### 3 - Implement code depend on test cases

```ruby
def self.lastest_active_days_of_phones
    find_by_sql(
      <<SQL
      SELECT
        id,
        max(results.activation_date) as activation_date,
        results.phone_number as phone_number
      FROM (
             ### merge_act_and_deact_column count in group phone_number, is_not_sequence_activation is counted equal to 1
             SELECT
               id,
               phone_number,
               merge_act_and_deact_column.activation_date,
               count(merge_act_and_deact_column.activation_date) AS is_not_sequence_activation
             FROM
               (
                 ### COMMENTS: active phones with activation_date column
                 SELECT
                   c1.id,
                   c1.phone_number,
                   c1.activation_date
                 FROM contacts c1
                   JOIN (SELECT
                           phone_number,
                           sum(IF(deactivation_date IS NULL, 1, 0)) count_active
                         FROM contacts
                         GROUP BY phone_number
                         HAVING count_active > 0
                        ) active_c ON active_c.phone_number = c1.phone_number
                 UNION ALL
                  ### COMMENTS: active phones with deactivation_date column
                 SELECT
                   c1.id,
                   c1.phone_number,
                   c1.deactivation_date
                 FROM contacts c1
                   JOIN (SELECT
                           phone_number,
                           sum(IF(deactivation_date IS NULL, 1, 0)) count_active
                         FROM contacts
                         GROUP BY phone_number
                         HAVING count_active > 0
                        ) active_c ON active_c.phone_number = c1.phone_number
                 WHERE c1.deactivation_date IS NOT NULL
               ) AS merge_act_and_deact_column

             ### Group twice to count duplicate of activation_date in phone_number group
             GROUP BY merge_act_and_deact_column.phone_number,  merge_act_and_deact_column.activation_date
             HAVING is_not_sequence_activation = 1) results
      GROUP BY phone_number;
SQL
    )
  end

```

## Implement input CSV and output CSV

#### 1 - store as a file first if import waste lots of time

#### 2 - Invoke files to import to CSV
    + Use bulk_import in Mysql for faster performance

#### 3 - Add uniqueness [:phone_number, :deactivation_date] to avoid bad data

#### 4 - Add indexes for phone_number and deactivation_date for group_by purpose searching faster

#### 5 - Keep thin controllers and models by services

#### 6 - Use EXPLAIN to see

```table
id,select_type,table,type,possible_keys,key,key_len,ref,rows,Extra
1,PRIMARY,<derived2>,ALL,,,,,86,Using temporary; Using filesort
2,DERIVED,<derived3>,ALL,,,,,86,Using temporary; Using filesort
3,DERIVED,c1,ALL,"index_contacts_on_phone_number_and_deactivation_date,index_contacts_on_phone_number",,,,21,Using where
3,DERIVED,<derived4>,ref,<auto_key0>,<auto_key0>,63,tiny_mini.c1.phone_number,2,
4,DERIVED,contacts,index,"index_contacts_on_phone_number_and_deactivation_date,index_contacts_on_phone_number",index_contacts_on_phone_number_and_deactivation_date,67,,21,Using index
5,UNION,<derived6>,ALL,,,,,21,Using where
5,UNION,c1,ref,"index_contacts_on_phone_number_and_deactivation_date,index_contacts_on_phone_number",index_contacts_on_phone_number_and_deactivation_date,63,active_c.phone_number,2,Using where; Using index
6,DERIVED,contacts,index,"index_contacts_on_phone_number_and_deactivation_date,index_contacts_on_phone_number",index_contacts_on_phone_number_and_deactivation_date,67,,21,Using index
,UNION RESULT,"<union3,5>",ALL,,,,,,Using temporary
```
