import { Data } from './data';
import { Header } from './header';
import { Search } from './search';

export const Layout = <template>
  <Header />

  <main>
    <Search as |data|>
      <Data @data={{data}} />
    </Search>
  </main>
</template>;
