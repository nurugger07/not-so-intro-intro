# Not So Intro, Intro

## How to use the presentation

1. clone the repo
2. set the `background_node` in the session app config
3. start the "background" app

   ```
   $ cd apps/background
   $ iex --sname background -S mix
   ```

4. set the `session_node` in the background app config
5. start the "session" app
   
   ```
   $ cd apps/session
   $ iex --sname session -S mix
   ```

The presentation will start!

## Pregressing through slides

To progress through slides hit "return" in the session app iex repl and then:

```
iex> Session.next
```

When you get to the slide 9 and hear "I have no idea..." message. Go to the background app window and enter:

```
iex> :sys.suspend(Background.Messenger)
```

and in the code of "lib/messenger.ex" comment out the folloing lines:

```
  def handle_info(9, state) do
    send(self(), :bad_message)
    {:noreply, state}
  end
```

then in the background app window:

```
iex> c("lib/messenger.ex")
iex> :sys.resume(Background.Messenger)
```

Once that is done, return to the session window and run the `Session.next/1` function.


## Customizing

You can use this app for your own presentations and customize the slides!

In `Background.Messenger` there is a `@steps` module variable that contains the slides/progression. Edit this and supply the title and doc module.
The default doc modules are stored in `background/markdown/intro.ex` but you can customize that too :) The slides are just generated from module
docs.
