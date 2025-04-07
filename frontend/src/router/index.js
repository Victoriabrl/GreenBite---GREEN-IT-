import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import ProductsModule from '@/components/ProductsModule'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    },
    
    // Games Module Routes
    {
      path: '/products',
      redirect: '/products/list/all' // Redirect to the games list
    },
    {
      path: '/products/:action/:id',
      name: 'products',
      component: ProductsModule,
      props: true
    },
  ]
})
