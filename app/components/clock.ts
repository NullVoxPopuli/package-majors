import { cell, resource } from 'ember-resources';

const usDateTime = new Intl.DateTimeFormat('en-US', {
  hour: 'numeric',
  minute: 'numeric',
  second: 'numeric',
  hour12: false,
});

export const Clock = resource(({ on }) => {
  let time = cell(new Date());
  let interval = setInterval(() => (time.current = new Date()), 1000);

  on.cleanup(() => clearInterval(interval));

  return () => usDateTime.format(time.current);
});
