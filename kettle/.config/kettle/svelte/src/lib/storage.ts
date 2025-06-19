import type { Writable } from 'svelte/store';
import { writable, get } from 'svelte/store'
import { browser } from '$app/environment';

const storage = <T>(key: string, initValue: T): Writable<T> => {
  const store = writable(initValue);
  if (!browser) return store;

  const storedValueStr = localStorage.getItem(key);
  if (storedValueStr != null) store.set(JSON.parse(storedValueStr));

  store.subscribe((val) => {
    if (!val) {
      localStorage.removeItem(key)
    } else {
      localStorage.setItem(key, JSON.stringify(val))
    }
  })

  window.addEventListener('storage', () => {
    const storedValueStr = localStorage.getItem(key);
    if (storedValueStr == null) return;

    const localValue: T = JSON.parse(storedValueStr)
    if (localValue !== get(store)) store.set(localValue);
  });

  return store;
}

export default storage
