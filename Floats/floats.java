import java.lang.Math;

class floats {
    public static void main(String[] args) {
        System.out.println("Calculating Std. Devation with floats");
        
        float num1 = (float) 10000.1; //These numbers change depending on what numbers from table we are using
        float num2 = (float) 10000.2;
        float num3 = (float) 10000.3;

        float A;
        float B;

        float squared_sum = SquaredSum(num1, num2, num3);
        float sumA = Sum(num1, num2, num3);

        float average = Average(num1, num2, num3);
        float x1 = num1 - average;
        float x2 = num2 - average;
        float x3 = num3 - average;

        float x1_squared = x1 * x1;
        float x2_squared = x2 * x2;
        float x3_squared = x3 * x3;

        float sumB = Sum(x1_squared, x2_squared, x3_squared);

        A = ((float) 0.5) * (squared_sum - ((sumA * sumA)/3));

        B = ((float) 0.5) * (sumB);

        System.out.println(squared_sum);
        System.out.println((sumA*sumA)/3);
        System.out.println(sumB);

        System.out.println("-----------Answers-----------");

        System.out.print("Sigma A: ");
        System.out.println(A);

        System.out.print("Sigma B: ");
        System.out.println(B);
    }

    public static float Sum(float num1, float num2, float num3)
    {
        float result;
        result = num1 + num2 + num3;
        return result;
    }

    public static float SquaredSum(float num1, float num2, float num3)
    {
        float result;
        num1 = num1 * num1;
        num2 = num2 * num2;
        num3 = num3 * num3;
        result = num1 + num2 + num3;
        return result;
    }

    public static float Average(float num1, float num2, float num3)
    {
        float result;
        float sum;
        sum = num1 + num2 + num3;
        result = sum/3;
        return result;
    }
}