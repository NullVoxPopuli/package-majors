import { modifier } from 'ember-modifier';

const intensify = modifier((element) => {
  let animation = element.animate(
    [
      { transform: 'translateX(1px)' },
      { transform: 'translateY(1px)' },
      { transform: 'translateX(-1px)' },
    ],
    {
      duration: 100,
      iterations: Infinity,
    }
  );

  return () => animation.cancel();
});

export const Excite = <template>
  <div {{intensify}} style="position: fixed; bottom: 1rem; left: 1rem;">
    🥳
  </div>
</template>;
