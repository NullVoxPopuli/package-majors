import type { TOC } from '@ember/component/template-only';

/**
 * Modified from:
 * https://codepen.io/enbee81/pen/GRJVgXj?editors=1100
 */
export const NameInput: TOC<{
  Args: {
    value?: string;
  };
}> = <template>
  <div class="input-group">
    <label class="input-group__label" for="myInput">Package Name</label>
    <input type="text" class="input-group__input" name="packageName" value={{@value}} />
  </div>
  <style>
    .input-group { width: 100%; max-width: 20em; display: flex; flex-direction: column; z-index: 2;
    } @supports (mix-blend-mode: darken) { .input-group { position: relative; mix-blend-mode:
    lighten; } .input-group__label { position: absolute; left: 3em; top: -0.28em; background: #000;
    } } .input-group__label { padding: 0 0.5em; margin-bottom: 0.5em; text-transform: uppercase;
    letter-spacing: 0.1em; color: #ccd; color: rgba(255, 200, 255, 0.8); cursor: pointer;
    margin-top: -0.2rem; } .input-group__input { color: #fff; font-size: 1.5rem; line-height: 1;
    border-style: none; outline: none; height: calc(1em + 1.6em + 0.5em); width: 100%; padding:
    0.4rem 1rem; border: 0.5rem solid transparent; background-image: linear-gradient(#000, #000),
    linear-gradient(120deg, #f0f 0%, #0ff 50%, #9f9 100%); background-origin: border-box;
    background-clip: padding-box, border-box; border-radius: 1.5rem; background-size: 200% 100%;
    transition: background-position 0.8s ease-out; } .input-group__input:hover {
    background-position: 100% 0; }
  </style>
</template>;
