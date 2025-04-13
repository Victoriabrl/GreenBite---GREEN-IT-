import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import ProductsModule from '@/components/ProductsModule'
import VendorsModule from '@/components/VendorsModule'
import ProfileModule from '@/components/ProfileModule.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    },
    
    // Products Module Routes
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

    // Vendors Module Routes
    {
      path: '/vendors',
      redirect: '/vendors/list/all' // Redirect to the vendors list
    },
    {
      path: '/vendors/:action/:id',
      name: 'vendors',
      component: VendorsModule,
      props: true
    },

    // Auth Module Routes
    {
      path: '/profile/:action',
      name: 'profile',
      component: ProfileModule,
      props: true
    },
  ]
})
