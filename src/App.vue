<template>
  <div v-if="isDrizzleInitialized" id="app">
    <img alt="Vue logo" src="./assets/logo.png" />

    <div class="section">
      <h2>Show the Accounts</h2>
      <drizzle-account units="Ether" :precision="2" />
    </div>
    <hr>
    <TreeChart
            :json="data"
            :class="{landscape: landscape.length}"
            @click-node="clickNode"
    />
    <hr>

    <div class="section">
      <h2>Tutorial Token</h2>
      <TutorialToken />
    </div>

    <div class="section">
      <h2>Simple Storage</h2>
      <SimpleStorage />
    </div>

    <div class="section">
      <h2>Complex Storage</h2>
      <ComplexStorage />
    </div>
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from 'vuex';
import TutorialToken from './TutorialToken.vue';
import SimpleStorage from './SimpleStorage.vue';
import ComplexStorage from './ComplexStorage.vue';
import TreeChart from './TreeChart.vue';

export default {
  name: 'app',
  components: {
    ComplexStorage,
    TutorialToken,
    SimpleStorage,
    TreeChart,
  },
  data() {
    return {
      landscape: [],
      data: {
        text: 'Thesis BLABLABLA',
        name: 'root',
        image_url: 'https://static.refined-x.com/static/avatar.jpg',
        children: [
          {
            name: 'children1',
            text: 'Argument',
            image_url: 'https://static.refined-x.com/static/avatar.jpg',
          },
          {
            name: 'children2',
            text: 'Argument',
            image_url: 'https://static.refined-x.com/static/avatar.jpg',
            children: [
              {
                name: 'grandchild',
                text: 'Argument',
                image_url: 'https://static.refined-x.com/static/avatar.jpg',
              },
              {
                name: 'grandchild2',
                text: 'Argument',
                image_url: 'https://static.refined-x.com/static/avatar.jpg',
              },
              {
                name: 'grandchild3',
                text: 'Argument',
                image_url: 'https://static.refined-x.com/static/avatar.jpg',
              },
            ],
          },
        ],
      },
    };
  },
  methods: {
    clickNode(node) {
      // eslint-disable-next-line
      console.log(node)
    },
  },
  computed: mapGetters('drizzle', ['isDrizzleInitialized']),
};
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
