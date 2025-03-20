## FloatingView Package

The `FloatingView` package enables you to create a floating window similar to YouTube's floating video feature. This allows the window to float on the screen and be draggable while scrolling.

<img src="https://github.com/ccprogrammer/floating-view/raw/main/lib/assets/floating-view-video.gif?raw=true" alt="The example app running in iOS"  width="100%" />

### Integration Steps

To integrate the package into your Flutter application, follow these steps:

1. **Wrap the Screen:**

   Wrap the screen where you want to display the `FloatingView`:

   ```dart
   late final FloatingController _controller = FloatingController(
       context,
       initialPosition: FloatingPosition.bottomLeft,
   );

   @override
   void dispose() {
       super.dispose();
       _controller.dispose();
   }

   @override
   Widget build(BuildContext context) {
       return FloatingView(
           controller: _controller,
           childBuilder: () => Scaffold(
               body: ItemBuilder(list: dummyList, controller: _controller),
           ),
       );
   }
   ```

   **Note:** `FloatingView` will disappear when changing routes. To display it across routes, wrap your desired route screen with the `FloatingView` and use the same controller. The controller can be passed down in the widget tree or stored in state management solutions such as BLoC, Provider, etc. The `FloatingView` will be passed down across the screen using the `Hero` widget, which is currently the only option available.

   ```dart
   Navigator.push(
       context,
       MaterialPageRoute(
           builder: (context) => FloatingView(
               controller: _controller,
               childBuilder: () => NavigationTestScreen(),
           ),
       ),
   );
   ```

2. **Initialize the `FloatingView`:**

   Initialize the controller and store the widget you want to display, such as a video, screen, or text. Here is an example of using `FloatingView` with a Video Player or a simple screen:

   ```dart
   void onTap(dynamic data) {
       switch (data) {
           case Video _:
               VideoPlayerController? videoController;
               videoController = VideoPlayerController.asset(data.url)
                   ..initialize().then((_) {
                       videoController?.play();
                       setState(() {});
                   })
                   ..addListener(() {
                       setState(() {});
                   });

               widget.controller.initialize(
                   maxChild: MaximizedVideo(
                       videoController: videoController,
                       floatingController: widget.controller,
                       video: data,
                   ),
                   minChild: MinimizedVideo(
                       videoController: videoController,
                       floatingController: widget.controller,
                       video: data,
                   ),
                   onDispose: () {
                       videoController?.dispose();
                   },
               );
               break;

           case News _:
               widget.controller.initialize(
                   maxChild: MaximizedNewsScreen(
                       news: data,
                       controller: widget.controller,
                   ),
                   minChild: MinimizedNewsScreen(
                       news: data,
                       controller: widget.controller,
                   ),
                   onDispose: () {},
               );
               break;

           default:
               break;
       }
   }
   ```

   **Note:** `controller.initialize()` will run the previous `onDispose()` method to clear the previous controller data if you initialize another `FloatingView` while having an active one.

3. **Using the APIs:**

   You can use the passed-down controller to control the `FloatingView` state like this:

   ```dart
   Padding(
       padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
       child: Row(
           children: [
               GestureDetector(
                   onTap: () {
                       widget.controller.close();
                   },
                   child: Icon(Icons.close, size: 24),
               ),
               const SizedBox(width: 20),
               GestureDetector(
                   onTap: () {
                       widget.controller.toggleSize();
                   },
                   child: Icon(Icons.aspect_ratio, size: 24),
               ),
           ],
       ),
   );
   ```

### Available API Methods in `FloatingController`

1. **Initialize the Floating View:**

   ```dart
   controller.initialize({
       required Widget maxChild,
       required Widget minChild,
       required VoidCallback onDispose,
   })
   ```

2. **Close an Active Floating View:**

   ```dart
   controller.close()
   ```

3. **Toggle the Floating View Size:**

   ```dart
   controller.toggleSize()
   ```

4. **Dispose the controller:**

   ```dart
   controller.dispose()
   ```
