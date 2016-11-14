package secret;
/**
 * Created by santoshkumar on 11/13/16.
 */

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import spark.Request;
import spark.route.RouteOverview;

import java.math.BigInteger;
import java.security.SecureRandom;

import static spark.Spark.get;
import static spark.Spark.post;
import static spark.Spark.threadPool;

public class Server {
    private static final Logger LOG = LoggerFactory.getLogger(Server.class);

    static class Whatever {
        final int integer;
        final String string;
        final double floating;

        Whatever(int integer, String string, double floating) {
            this.integer = integer;
            this.string = string;
            this.floating = floating;
        }
    }
    static String toJson(Object object) {
        return new Gson().toJson(object);
    }

    public static void main(String[] args) {
        LOG.info("here");

        // cannot namespace static file location
        // cannot tie multiple address to the same resource
        threadPool(10, 5, 30000);
        RouteOverview.enableRouteOverview();

        //  port(5678); <- Uncomment this if you want spark to listen to port 5678 in stead of the default 4567


        get("/get/:key1/", (request, response) -> {
            //return request.params(":key") + ":" + request.queryParams("qp");


            return request.params(":key1") + ":" +request.params(":key2");

        });

        post("/post/", (request, response) -> {
            return request.queryParams("key");
        });


        get("/get2/", (request, response) -> {
            final int CERTAINTY = 256;
            final SecureRandom random = new SecureRandom();

            final BigInteger secret = new BigInteger("123");

            // prime number must be longer then secret number
            final BigInteger prime = new BigInteger(secret.bitLength() + 1, CERTAINTY, random);

            // 2 - at least 2 secret parts are needed to view secret
            // 5 - there are 5 persons that get secret parts
            final SecretShare[] shares = Shamir.split(secret, 2, 5, prime, random);
            //int n =
            //System.out.println("n:"+n);
            // we can use any combination of 2 or more parts of secret


            int size = request.queryParams().size();
            System.out.println(size);

            System.out.println(request.url());
            System.out.println("size:"+request.params());
            int i = Integer.parseInt(request.queryParams("qp1"));
            int j = Integer.parseInt(request.queryParams("qp2"));
            //int k = Integer.parseInt(request.queryParams("qp3"));


            SecretShare[] sharesToViewSecret = new SecretShare[]{shares[i], shares[j]}; // 0 & 1
            BigInteger result = Shamir.combine(sharesToViewSecret, prime);
            System.out.println(result.equals(secret));

            return result+" the secret code is " +String.valueOf(result.equals(secret));
        });

        get("/get1/", (request, response) -> {
            final int CERTAINTY = 256;
            final SecureRandom random = new SecureRandom();

            final BigInteger secret = new BigInteger("123");

            // prime number must be longer then secret number
            final BigInteger prime = new BigInteger(secret.bitLength() + 1, CERTAINTY, random);

            // 2 - at least 2 secret parts are needed to view secret
            // 5 - there are 5 persons that get secret parts
            final SecretShare[] shares = Shamir.split(secret, 2, 5, prime, random);
            //int n =
            //System.out.println("n:"+n);
            // we can use any combination of 2 or more parts of secret



            System.out.println(request.url());
            System.out.println("size:"+request.params());
            int i = Integer.parseInt(request.queryParams("qp1"));

            SecretShare[] sharesToViewSecret = new SecretShare[]{shares[i]}; // 0 & 1
            BigInteger result = Shamir.combine(sharesToViewSecret, prime);
            System.out.println(result.equals(secret));
            return result+" the secret code is " +String.valueOf(result.equals(secret));
        });

        get("/get3/", (request, response) -> {
            final int CERTAINTY = 256;
            final SecureRandom random = new SecureRandom();

            final BigInteger secret = new BigInteger("123");

            // prime number must be longer then secret number
            final BigInteger prime = new BigInteger(secret.bitLength() + 1, CERTAINTY, random);

            // 2 - at least 2 secret parts are needed to view secret
            // 5 - there are 5 persons that get secret parts
            final SecretShare[] shares = Shamir.split(secret, 2, 5, prime, random);
            //int n =
            //System.out.println("n:"+n);
            // we can use any combination of 2 or more parts of secret



            System.out.println(request.url());
            System.out.println("size:"+request.params());
            int i = Integer.parseInt(request.queryParams("qp1"));
            int j = Integer.parseInt(request.queryParams("qp2"));
            int k = Integer.parseInt(request.queryParams("qp3"));

            SecretShare[] sharesToViewSecret = new SecretShare[]{shares[i], shares[j], shares[k]}; // 0 & 1
            BigInteger result = Shamir.combine(sharesToViewSecret, prime);
            System.out.println(result.equals(secret));
            return result+" the secret code is " +String.valueOf(result.equals(secret));
        });

        post("/post/", (request, response) -> {
            return request.queryParams("key");
        });

        get("/ret_json", (request, response)  -> {
            response.type("application/json");
            Whatever ret = new Whatever(1, "number", 1.1);
            final int CERTAINTY = 256;
            final SecureRandom random = new SecureRandom();

            final BigInteger secret = new BigInteger("123");

            // prime number must be longer then secret number
            final BigInteger prime = new BigInteger(secret.bitLength() + 1, CERTAINTY, random);

            // 2 - at least 2 secret parts are needed to view secret
            // 5 - there are 5 persons that get secret parts
            final SecretShare[] shares = Shamir.split(secret, 2, 5, prime, random);

            for(int i=0; i<shares.length; i++){
                System.out.println(shares[i]);
            }
            // we can use any combination of 2 or more parts of secret
            SecretShare[] sharesToViewSecret = new SecretShare[]{shares[0], shares[1]}; // 0 & 1
            BigInteger result = Shamir.combine(sharesToViewSecret, prime);
            System.out.println(result.equals(secret));
            return toJson(shares);
        });

        get("/ret_result", (request, response)  -> {
            response.type("application/json");
            String finalResult = "";
            final int CERTAINTY = 256;
            final SecureRandom random = new SecureRandom();

            final BigInteger secret = new BigInteger("123");

            // prime number must be longer then secret number
            final BigInteger prime = new BigInteger(secret.bitLength() + 1, CERTAINTY, random);

            // 2 - at least 2 secret parts are needed to view secret
            // 5 - there are 5 persons that get secret parts
            final SecretShare[] shares = Shamir.split(secret, 2, 5, prime, random);

            for(int i=0;i <shares.length; i++){
                //System.out.println(shares[i]);
                finalResult = finalResult.concat(shares[i].toString());
            }
            System.out.println(finalResult);

            return finalResult;
        });


    }
}
