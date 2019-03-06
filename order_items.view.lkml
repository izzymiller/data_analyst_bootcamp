view: order_items {
  sql_table_name: public.order_items ;;

dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    #description: "this is primary key"
    #hidden: yes
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
#########################################
# (TRAINING-1) ${TABLE} references the table (database object) defined in the View (see sql_table_name at top)
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
#(TRAINING-4) Referencing fields in other views
  dimension: profit {
    type: number
    value_format_name: usd
    sql: ${sale_price} -
      ${inventory_items.cost} ;;
    group_label: "Sales Measures"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

# (TRAINING-SUBSTITUTION OPERATOR TO REF LOOKER OBJECT ${sale_price} DIMENSION ABOVE)
  measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
    group_label: "Sales Measures"

  }
# (TRAINING-SUBSTITUTION OPERATOR TO REF LOOKER OBJECT ${sale_price} DIMENSION ABOVE)
  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    group_label: "Sales Measures"
  }
#(TRAINING) Filtered measures (note use of field from another view)
  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price};;
    filters:  {
      field: users.is_new_customer
      value: "Yes"
    }
  }

  # ----- Sets of fields for drilling ------

  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
