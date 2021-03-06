with customers as (
    select * from {{ ref('stg_coffee_shop__customers') }}
),

orders as (
    select * from {{ ref('stg_coffee_shop__orders') }}
),

customer_orders as (
    select
        customer_id,
        count(*) as number_of_orders,
        min(created_at) as first_order_at
    from orders
    group by 1
),

joined as (
    select
        customers.customer_id,
        customers.name,
        customers.email,
        customer_orders.first_order_at,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers
    left join customer_orders
        using (customer_id)
)

select * from joined
