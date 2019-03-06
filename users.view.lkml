view: users {
  sql_table_name: public.users ;;

  dimension: id {
  #  hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    label: "user age"
    description: "age of user"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
#################################################
#create dimension to show TYPE string (Training)
#################################################

dimension: full_name {
  type: string
  sql: ${first_name} || ' '|| ${last_name} ;;
}

# dimension: full_name {
#   type: string
#   sql: ${first_name} || ' ' || ${last_name};;
# }

#Shows dimension TYPE number  (Training)
  dimension: days_since_signup {
    description: "Number of days since signup"
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }

#(TRAINING) Shows dimension type yesno (Boolean field created)
  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

#(TRAINING) Shows dimension type tier
  dimension: days_since_signup_tier {
    type: tier
    tiers: [0, 30, 90, 180, 360, 720]
    sql: ${days_since_signup} ;;
   style: integer
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

#(TRAINING) filtered measure
  measure: count_female_users {
    type: count
    filters:  {
      field: gender
      value: "Female"
    }
  }

#(TRAINING) Measure defining another measure
  measure: percentage_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0*${count_female_users}
      /NULLIF(${count}, 0) ;;
  }
}
