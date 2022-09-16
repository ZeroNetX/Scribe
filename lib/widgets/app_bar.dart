import '../imports.dart';

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      color: Colors.amber,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(flex: 1),
          const Text(
            'Scribe',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2109),
            ),
          ),
          const Spacer(flex: 14),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color(0xFF2F2109),
              ),
              minimumSize: MaterialStateProperty.all(
                const Size(90, 45),
              ),
            ),
            child: const Text("Sign In"),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
