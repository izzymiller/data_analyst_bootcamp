view: user_order_facts {
  derived_table: {
    sql: select user_id as user_id,
      COUNT(*) as lifetime_orders,
      MAX(order_items.created_at) as most_recent_purchase_at
      from order_items
      group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: most_recent_purchase_at {
    type: time
    sql: ${TABLE}.most_recent_purchase_at ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, most_recent_purchase_at_time]
  }
}
