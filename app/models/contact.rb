class Contact < ApplicationRecord
  scope :ordered_by_phone_active_date, -> { all.order(phone_number: 'asc', activation_date: 'asc') }

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

end


